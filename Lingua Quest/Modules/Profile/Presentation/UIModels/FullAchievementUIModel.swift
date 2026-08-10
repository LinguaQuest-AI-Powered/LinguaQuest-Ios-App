//
//  FullAchievementUIModel.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import SwiftUI

struct FullAchievementUIModel: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let iconUrl: String?
    let status: AchievementStatus
    let progressPercent: Int
    let xpReward: Int
    let coinsReward: Int
    let earnedAt: String?
    
    var uiBgColor: Color {
        return isEarned ? .appSurfaceCardWarm : .appSurfaceCardMuted
    }
    
    var isEarned: Bool {
        return status.isEarned
    }
    
    var uiIcon: Image.SystemIcon {
        let titleLower = title.lowercased()
        if titleLower.contains("explorer") || titleLower.contains("world") {
            return .globeAmericasFill
        } else if titleLower.contains("week") || titleLower.contains("streak") || titleLower.contains("day") {
            return .flameFill
        } else if titleLower.contains("perfect") || titleLower.contains("master") || titleLower.contains("champion") {
            return .trophyFill
        } else if titleLower.contains("vocab") || titleLower.contains("word") {
            return .textformatAlt
        } else if titleLower.contains("speak") || titleLower.contains("voice") {
            return .micFill
        } else if titleLower.contains("listen") || titleLower.contains("ear") {
            return .speakerWave2Fill
        } else if titleLower.contains("fast") || titleLower.contains("speed") || titleLower.contains("quick") {
            return .boltFill
        } else if titleLower.contains("smart") || titleLower.contains("brain") || titleLower.contains("mind") {
            return .lightbulbFill
        } else if titleLower.contains("target") || titleLower.contains("goal") {
            return .target
        } else if titleLower.contains("first") || titleLower.contains("beginner") {
            return .starCircleFill
        }
        return .starFill
    }

    var uiIconColor: Color {
        let titleLower = title.lowercased()
        if titleLower.contains("explorer") || titleLower.contains("world") {
            return .appTealGreen
        } else if titleLower.contains("week") || titleLower.contains("streak") || titleLower.contains("day") {
            return .appAccentOrange
        } else if titleLower.contains("perfect") || titleLower.contains("master") || titleLower.contains("champion") {
            return .appBrandBrown
        } else if titleLower.contains("fast") || titleLower.contains("speed") {
            return .appAccentOrange
        } else if titleLower.contains("smart") || titleLower.contains("brain") || titleLower.contains("mind") {
            return .appAccentTeal
        }
        return .appBrandBrown
    }
}
