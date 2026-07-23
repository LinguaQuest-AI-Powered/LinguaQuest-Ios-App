//
//  FullAchievementEntity.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct FullAchievementEntity: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let iconUrl: String?
    let status: AchievementStatus
    let progressPercent: Int
}

enum AchievementStatus: String, Equatable {
    case earned = "EARNED"
    case locked = "LOCKED"
    
    // Fallback if parsing fails or unexpected status
    case unknown = "UNKNOWN"
}

struct AchievementsDataEntity: Equatable {
    let earnedCount: Int
    let inProgressCount: Int
    let xpEarned: Int
    let achievements: [FullAchievementEntity]
}
