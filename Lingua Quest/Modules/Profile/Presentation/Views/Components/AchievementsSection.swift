//
//  LinguaAchievementsSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct AchievementsSection: View {
    let achievements: [AchievementUIModel]
    var onViewAllTapped: () -> Void
    var onAchievementTapped: ((AchievementUIModel) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            
            SectionHeader(
                title: L10n.Profile.achievementsTitle,
                actionTitle: L10n.Profile.viewAll,
                onActionTapped: onViewAllTapped
            )
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(achievements) { achievement in
                        Button(action: {
                            onAchievementTapped?(achievement)
                        }) {
                            AchievementCard(
                                title: achievement.title,
                                subtitle: achievement.subtitle,
                                icon: achievement.uiIcon,
                                isEarned: achievement.isEarned
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let mockAchievements = [
        AchievementUIModel(
            id: "1",
            title: "Wild Explorer",
            subtitle: "Complete 10 lessons in...",
            uiIcon: .trophyFill,
            uiIconColor: .appBrandBrown,
            uiBgColor: .appSurfaceCardWarm,
            iconUrl: nil,
            status: .earned,
            progressPercent: 100,
            xpReward: 50,
            coinsReward: 20,
            earnedAt: "2026-07-18"
        ),
        AchievementUIModel(
            id: "2",
            title: "Perfect Week",
            subtitle: "Complete 10 lessons in...",
            uiIcon: .starFill,
            uiIconColor: .appAccentTeal,
            uiBgColor: .white,
            iconUrl: nil,
            status: .inProgress,
            progressPercent: 60,
            xpReward: 100,
            coinsReward: 50,
            earnedAt: nil
        )
    ]
    
    AchievementsSection(achievements: mockAchievements) {
        print("View All Achievements Tapped!")
    }
    .padding(.vertical)
    .background(Color.appBackgroundWarm)
}
