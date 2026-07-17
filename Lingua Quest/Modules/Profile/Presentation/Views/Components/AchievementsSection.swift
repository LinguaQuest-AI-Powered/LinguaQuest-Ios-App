//
//  LinguaAchievementsSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct AchievementsSection: View {
    let achievements: [AchievementEntity]
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

// MARK: - UI Mapping Extension
private extension AchievementEntity {
    var uiIcon: Image.SystemIcon {
        switch type {
        case .wildExplorer: return .trophyFill
        case .perfectWeek: return .starFill
        }
    }
    
    var uiIconColor: Color {
        switch type {
        case .wildExplorer: return .appProfileLogoBrown
        case .perfectWeek: return .appProfileAchievementTeal
        }
    }
    
    var uiBgColor: Color {
        switch type {
        case .wildExplorer: return .appProfileCardBackground
        case .perfectWeek: return .white
        }
    }
}

// MARK: - Preview
#Preview {
    let mockAchievements = [
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
    ]
    
    AchievementsSection(achievements: mockAchievements) {
        print("View All Achievements Tapped!")
    }
    .padding(.vertical)
    .background(Color.appViewBackground)
}
