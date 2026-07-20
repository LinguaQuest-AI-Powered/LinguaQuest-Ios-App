//
//  ProfileView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(Router.self) private var router
    @State var viewModel: ProfileViewModel
    
    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
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
                    Color.appBackgroundWarm.ignoresSafeArea()
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
                        router.push(.editProfile)
                    },
                    onViewAllAchievements: {
                        router.push(.achievements)
                    },
                    onViewAllExplorers: {
                        router.push(.leaderboard)
                    },
                    onSettingsTapped: {
                        viewModel.navigateToSettings()
                    }
                )
            }
        }
        .onAppear {
            viewModel.fetchProfileData()
        }
    }
}
