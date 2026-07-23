//
//  WeeklyRewardEntity.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct WeeklyRewardEntity: Equatable {
    let claimedThisWeek: Bool
    let rewardXp: Int
    let rewardCoins: Int
}

struct ClaimRewardResultEntity: Equatable {
    let xpAwarded: Int
    let coinsAwarded: Int
    let newXpBalance: Int
    let newCoinsBalance: Int
}
