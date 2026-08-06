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
}
