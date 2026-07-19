//
//  ProfileContentView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileContentView: View {
    // MARK: - Properties
    let coinsValue: String
    let gemsValue: String
    let userName: String
    let userLevel: Int
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
     
            AppHeaderView(starCount: 15000000, coinCount: 20000)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ProfileHeader(
                        userName: userName,
                        userLevel: userLevel,
                        avatarImage: nil,
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

#Preview {
    ProfileContentView(
        coinsValue: "1,250",
        gemsValue: "45",
        userName: "Explorer Alex",
        userLevel: 12,
        xpValue: "4,500",
        streakValue: "7 Days",
        worldsValue: "2",
        languageName: L10n.Onboarding.languageFrench,
        journeyTitle: "Intermediate Journey",
        levelName: "B1 LEVEL",
        currentXP: 2450,
        targetXP: 3000,
        achievements: [
            AchievementUIModel(
                id: "1",
                title: "Wild Explorer",
                subtitle: "Complete 10 lessons in...",
                uiIcon: .trophyFill,
                uiIconColor: .appBrandBrown,
                uiBgColor: .appSurfaceCardWarm
            ),
            AchievementUIModel(
                id: "2",
                title: "Perfect Week",
                subtitle: "Complete 10 lessons in...",
                uiIcon: .starFill,
                uiIconColor: .appAccentTeal,
                uiBgColor: .white
            )
        ],
        topExplorers: [
            ExplorerUIModel(id: "1", name: "Marco Polo", uiRank: "1", uiXPAmount: "12,450 XP", avatarImage: nil, isTop: true),
            ExplorerUIModel(id: "2", name: "Amelia Earhart", uiRank: "2", uiXPAmount: "11,200 XP", avatarImage: nil, isTop: false),
            ExplorerUIModel(id: "3", name: "Ibn Battuta", uiRank: "3", uiXPAmount: "9,850 XP", avatarImage: nil, isTop: false)
        ],
        onEditProfile: {},
        onViewAllAchievements: {},
        onViewAllExplorers: {},
        onSettingsTapped: {}
    )
    .preferredColorScheme(.dark)
}
