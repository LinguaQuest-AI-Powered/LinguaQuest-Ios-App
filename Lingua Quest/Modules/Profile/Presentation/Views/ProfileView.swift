//
//  ProfileView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Loading Profile...")
                        .appTextStyle(.body, color: .appProfileTextMuted)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.appViewBackground.ignoresSafeArea()
                )
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error: \(error)")
                        .appTextStyle(.bodyBold, color: .red)
                    Button("Retry") {
                        viewModel.fetchProfileData()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.appViewBackground.ignoresSafeArea()
                )
            } else {
                ProfileContentView(
                    coinsValue: viewModel.coins,
                    gemsValue: viewModel.gems,
                    userName: viewModel.userName,
                    userLevel: viewModel.level,
                    xpValue: viewModel.totalXP,
                    streakValue: viewModel.streak,
                    worldsValue: viewModel.worlds,
                    languageName: viewModel.currentLanguage,
                    journeyTitle: viewModel.journeyTitle,
                    levelName: viewModel.languageLevel,
                    currentXP: viewModel.currentLanguageXP,
                    targetXP: viewModel.targetLanguageXP,
                    achievements: viewModel.achievements,
                    topExplorers: viewModel.topExplorers,
                    onEditProfile: {
                        // Navigate to Edit Profile
                    },
                    onViewAllAchievements: {
                        // Navigate to Achievements List
                    },
                    onViewAllExplorers: {
                        // Navigate to Leaderboard
                    }
                )
            }
        }
        .onAppear {
            viewModel.fetchProfileData()
        }
    }
}
