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
    
    var body: some View {
        VStack(spacing: 16) {
            
            SectionHeader(
                title: L10n.Profile.achievementsTitle,
                actionTitle: L10n.Profile.viewAll,
                onActionTapped: onViewAllTapped
            )
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(achievements) { achievement in
                        AchievementCard(
                            title: achievement.title,
                            subtitle: achievement.subtitle,
                            icon: achievement.uiIcon
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
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
    ]
    
    AchievementsSection(achievements: mockAchievements) {
        print("View All Achievements Tapped!")
    }
    .padding(.vertical)
    .background(Color.appBackgroundWarm)
}
