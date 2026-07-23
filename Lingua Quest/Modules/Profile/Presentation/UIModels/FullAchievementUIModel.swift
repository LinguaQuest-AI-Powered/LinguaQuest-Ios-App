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
    
    var uiBgColor: Color {
        return status == .earned ? .appSurfaceCardWarm : .appSurfaceCardMuted
    }
    
    var isEarned: Bool {
        return status == .earned
    }
}
