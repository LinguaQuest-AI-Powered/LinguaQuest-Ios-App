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

            VStack(spacing: 0) {
                LeaderboardHeaderView(viewModel: viewModel)

                if !viewModel.isLoading {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                if !viewModel.topUsers.isEmpty {
                                    LeaderboardPodiumView(topUsers: viewModel.topUsers)
                                }
                                
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
                LeaderboardSkeletonView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(HomeBackgroundView().ignoresSafeArea())
                    .shimmer()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("\(L10n.Common.error): \(error)")
                        .appTextStyle(.bodyBold, color: .red)
                    Button(L10n.Common.retry) {
                        viewModel.fetchLeaderboard()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(HomeBackgroundView().ignoresSafeArea())
            }
        }
        .background(HomeBackgroundView().ignoresSafeArea())
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

struct LeaderboardSkeletonView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Podium Fake
                HStack(alignment: .bottom, spacing: 12) {
                    // Rank 2
                    VStack(spacing: -30) {
                        Circle().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 60, height: 60).zIndex(1)
                        RoundedRectangle(cornerRadius: 16).fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 100, height: 130)
                    }
                    // Rank 1
                    VStack(spacing: -40) {
                        Circle().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 80, height: 80).zIndex(1)
                        RoundedRectangle(cornerRadius: 16).fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 120, height: 160)
                    }
                    // Rank 3
                    VStack(spacing: -30) {
                        Circle().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 60, height: 60).zIndex(1)
                        RoundedRectangle(cornerRadius: 16).fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 100, height: 130)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                // List Fake
                VStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        HStack(spacing: 16) {
                            Capsule().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 20, height: 20) // Rank
                            Circle().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 48, height: 48) // Avatar
                            VStack(alignment: .leading, spacing: 8) {
                                Capsule().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 120, height: 16)
                                Capsule().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 60, height: 12)
                            }
                            Spacer()
                            Capsule().fill(Color.appSurfaceCardMuted.opacity(0.5)).frame(width: 50, height: 16)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(Color.appSurfaceCard) // Card background
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.appBorderLight, lineWidth: 0)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.appBrandBrown.opacity(0.15))
                                .offset(y: 6) // Thicker bottom border effect
                        )
                        .padding(.bottom, 6)
                        .opacity(1.0 - Double(index) * 0.15)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}
