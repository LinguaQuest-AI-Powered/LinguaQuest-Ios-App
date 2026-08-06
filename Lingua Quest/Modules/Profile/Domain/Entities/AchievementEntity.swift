//
//  AchievementModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import Foundation

struct AchievementEntity: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let type: AchievementType
    let iconUrl: String?
    let status: AchievementStatus
    let progressPercent: Int
    let xpReward: Int
    let coinsReward: Int
    let earnedAt: String?
}

enum AchievementType: String {
    case wildExplorer
    case perfectWeek
    case generic
}
