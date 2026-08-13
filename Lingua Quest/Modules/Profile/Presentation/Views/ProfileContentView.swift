//
//  ProfileContentView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileContentView: View {
    // MARK: - Properties
    let rawCoins: Int
    let rawXP: Int
    let coinsValue: String
    let gemsValue: String
    let userName: String
    let userLevel: Int
    let avatarImage: String?
    let xpValue: String
    let streakValue: String
    let worldsValue: String
    
    // Progress Card Data
    let languageName: String
    let journeyTitle: String
    let levelName: String
    let currentXP: Int
    let targetXP: Int
    
    // Lists Data
    let achievements: [AchievementUIModel]
    let topExplorers: [ExplorerUIModel]
    
    // Actions
    var onEditProfile: () -> Void
    var onViewAllAchievements: () -> Void
    var onViewAllExplorers: () -> Void
    var onSettingsTapped: () -> Void
    var onAchievementTapped: ((AchievementUIModel) -> Void)? = nil
    
    @Environment(\.currentTutorialStep) private var currentTutorialStep
    
    @State private var animateItems: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
     
            AppHeaderView(starCount: rawXP, coinCount: rawCoins)
            
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                    ProfileHeader(
                        userName: userName,
                        userLevel: userLevel,
                        avatarImage: avatarImage,
                        onEditTapped: onEditProfile
                    )

                    .padding(.top, 16)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: animateItems)
                    .id(TutorialStepType.yourProfile)
                    .tutorialStep(.yourProfile)
                    
                    StatsGrid(
                        coinsValue: coinsValue,
                        xpValue: xpValue,
                        streakValue: streakValue,
                        worldsValue: worldsValue
                    )
                    .padding(.horizontal, 20)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: animateItems)
                    .id(TutorialStepType.profileStats)
                    .tutorialStep(.profileStats)
                    
                    LinguaLearningProgressCard(
                        languageName: languageName,
                        journeyTitle: journeyTitle,
                        levelName: levelName,
                        currentXP: currentXP,
                        targetXP: targetXP
                    )
                    .padding(.horizontal, 20)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateItems)
                    
                    LinguaSettingsPromptCard(action: onSettingsTapped)
                        .padding(.horizontal, 20)
                        .offset(y: animateItems ? 0 : 30)
                        .opacity(animateItems ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateItems)
                        .id(TutorialStepType.settings)
                        .tutorialStep(.settings)
                    
                    AchievementsSection(
                        achievements: achievements,
                        onViewAllTapped: onViewAllAchievements,
                        onAchievementTapped: onAchievementTapped
                    )
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateItems)
                    .id(TutorialStepType.achievements)
                    .tutorialStep(.achievements)
                    
                    TopExplorersSection(
                        explorers: topExplorers,
                        onViewAllExplorers: onViewAllExplorers
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateItems)
                    .id(TutorialStepType.leaderboard)
                    .tutorialStep(.leaderboard)
                }
                .padding(.bottom, 40)
            }
            .onChange(of: currentTutorialStep) { _, newStep in
                if let step = newStep {
                    withAnimation {
                        proxy.scrollTo(step, anchor: .center)
                    }
                }
            }
        } // closes ScrollViewReader
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
        .onAppear {
            withAnimation {
                animateItems = true
            }
        }
    }
}


