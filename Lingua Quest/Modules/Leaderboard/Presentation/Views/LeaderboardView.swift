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
                LeaderboardHeaderView(
                    viewModel: viewModel
                )
                
                ScrollView(showsIndicators: false) {
                    if !viewModel.isLoading && (!viewModel.topUsers.isEmpty || !viewModel.otherUsers.isEmpty) {
                        VStack(spacing: 0) {
                            LeaderboardPodiumView(topUsers: viewModel.topUsers)
                            
                            LeaderboardListView(users: viewModel.otherUsers)
                        }
                    }
                }
            }
            .opacity(isAnimating ? 1 : 0)
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.appBrandPrimary)
                }
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
}
