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
    let xpReward: Int
    let coinsReward: Int
    let earnedAt: String?
}

enum AchievementStatus: String, Equatable {
    case earned = "EARNED"
    case locked = "LOCKED"
    case unlocked = "UNLOCKED"
    case inProgress = "IN_PROGRESS"
    case unknown = "UNKNOWN"
    
    var isEarned: Bool {
        return self == .earned || self == .unlocked
    }
}

struct AchievementsDataEntity: Equatable {
    let earnedCount: Int
    let inProgressCount: Int
    let xpEarned: Int
    let achievements: [FullAchievementEntity]
}
