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
    
    @State private var animateItems: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
     
            AppHeaderView(starCount: rawXP, coinCount: rawCoins)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ProfileHeader(
                        userName: userName,
                        userLevel: userLevel,
                        avatarImage: "user1",
                        onEditTapped: onEditProfile
                    )
                    .padding(.top, 24)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: animateItems)
                    
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
                    
                    AchievementsSection(
                        achievements: achievements,
                        onViewAllTapped: onViewAllAchievements
                    )
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateItems)
                    
                    TopExplorersSection(
                        explorers: topExplorers,
                        onViewAllTapped: onViewAllExplorers
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateItems)
                }
                .padding(.bottom, 80)
            }
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


