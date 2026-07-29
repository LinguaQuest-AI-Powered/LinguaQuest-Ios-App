//
//  LeaderboardView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardView: View {
    @State var viewModel: LeaderboardViewModel
    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            VStack(spacing: 0) {
                LeaderboardHeaderView(viewModel: viewModel)

                if !viewModel.isLoading {
                    if !viewModel.topUsers.isEmpty {
                        LeaderboardPodiumView(topUsers: viewModel.topUsers)
                    }

                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LeaderboardListView(
                                users: viewModel.otherUsers,
                                isLoadingPreviousPage: viewModel.isLoadingPreviousPage,
                                isLoadingMore: viewModel.isLoadingNextPage,
                                onReachTop: { user in
                                    viewModel.loadPreviousPageIfNeeded(currentItem: user)
                                },
                                onReachBottom: { user in
                                    viewModel.loadNextPageIfNeeded(currentItem: user)
                                }
                            )
                        }
                        .onChange(of: viewModel.scrollToUserId) { _, targetId in
                            guard let targetId else { return }
                            scrollToUser(targetId, proxy: proxy)
                        }
                        .onChange(of: viewModel.isLoading) { _, isLoading in
                            if !isLoading, let targetId = viewModel.scrollToUserId {
                                scrollToUser(targetId, proxy: proxy)
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .opacity(isAnimating ? 1 : 0)

            if viewModel.isLoading {
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackgroundWarm.ignoresSafeArea())
            }

            if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error: \(error)")
                        .appTextStyle(.bodyBold, color: .red)
                    Button("Retry") {
                        viewModel.fetchLeaderboard()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackgroundWarm.ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.fetchLeaderboard()
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }

    private func scrollToUser(_ targetId: String, proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.4)) {
                proxy.scrollTo(targetId, anchor: .center)
            }
        }
    }
}
