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
    let achievements: [AchievementEntity]
    let topExplorers: [ExplorerEntity]
    
    // Actions
    var onEditProfile: () -> Void
    var onViewAllAchievements: () -> Void
    var onViewAllExplorers: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                LinguaProfileTopAppBar(coinsValue: coinsValue, gemsValue: gemsValue)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ProfileHeader(
                            userName: userName,
                            userLevel: userLevel,
                            avatarImage: nil,
                            onEditTapped: onEditProfile
                        )
                        .padding(.top, 24)
                        
                        StatsGrid(
                            coinsValue: coinsValue,
                            xpValue: xpValue,
                            streakValue: streakValue,
                            worldsValue: worldsValue
                        )
                        .padding(.horizontal, 20)
                        
                        LinguaLearningProgressCard(
                            languageName: languageName,
                            journeyTitle: journeyTitle,
                            levelName: levelName,
                            currentXP: currentXP,
                            targetXP: targetXP
                        )
                        .padding(.horizontal, 20)
                        
                        AchievementsSection(
                            achievements: achievements,
                            onViewAllTapped: onViewAllAchievements
                        )
                        
                        TopExplorersSection(
                            explorers: topExplorers,
                            onViewAllTapped: onViewAllExplorers
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                    .padding(.bottom, 80)
                }
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
            AchievementEntity(
                id: "1",
                title: "Wild Explorer",
                subtitle: "Complete 10 lessons in...",
                type: .wildExplorer
            ),
            
            AchievementEntity(
                id: "1",
                title: "Wild Explorer",
                subtitle: "Complete 10 lessons in...",
                type: .perfectWeek
            )
        ],
        topExplorers: [
            ExplorerEntity(id: "1", rank: 1, name: "Marco Polo", xp: 12450, avatarImage: nil),
            ExplorerEntity(id: "2", rank: 2, name: "Amelia Earhart", xp: 11200, avatarImage: nil),
            ExplorerEntity(id: "3", rank: 3, name: "Ibn Battuta", xp: 9850, avatarImage: nil)
        ],
        onEditProfile: {},
        onViewAllAchievements: {},
        onViewAllExplorers: {}
    )
}
