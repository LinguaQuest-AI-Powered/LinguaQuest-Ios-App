//
//  AchievementsDTOs.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct AchievementsResponseDTO: Decodable {
    let success: Bool
    let data: AchievementsDataDTO
}

struct AchievementsDataDTO: Decodable {
    let earnedCount: Int
    let inProgressCount: Int
    let xpEarned: Int
    let achievements: [FullAchievementDTO]
}

struct FullAchievementDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let iconUrl: String?
    let status: String
    let progressPercent: Int
    let xpReward: Int?
    let rewardXp: Int?
    let coinsReward: Int?
    let rewardCoins: Int?
    let earnedAt: String?
    let earnedDate: String?
}

struct WeeklyRewardResponseDTO: Decodable {
    let success: Bool
    let data: WeeklyRewardDataDTO
}

struct WeeklyRewardDataDTO: Decodable {
    let claimedThisWeek: Bool
    let rewardXp: Int
    let rewardCoins: Int
}

struct ClaimRewardResponseDTO: Decodable {
    let success: Bool
    let data: ClaimRewardDataDTO
}

struct ClaimRewardDataDTO: Decodable {
    let xpAwarded: Int
    let coinsAwarded: Int
    let newXpBalance: Int
    let newCoinsBalance: Int
}
