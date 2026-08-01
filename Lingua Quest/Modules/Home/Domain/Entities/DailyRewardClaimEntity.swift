//
//  DailyRewardClaimEntity.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct DailyRewardClaimEntity {
    let coinsAwarded: Int
    let xpAwarded: Int?
    let newCoinsBalance: Int
    let newXpBalance: Int
    let newStreakDays: Int?
    let nextDay: Int
}
