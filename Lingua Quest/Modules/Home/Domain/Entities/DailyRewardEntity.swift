//
//  DailyRewardEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

struct DailyRewardEntity {
    let claimedToday: Bool
    let currentDay: Int
    let cycleLength: Int
    let rewardCoins: Int
    let rewardXp: Int?
    let streakDays: Int?
}
