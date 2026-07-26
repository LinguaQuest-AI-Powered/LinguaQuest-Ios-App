//
//  GameFeatureEntities.swift
//  Lingua Quest
//
//  Created by AI on 25/07/2026.
//

import Foundation

struct StartLevelEntity {
    let targetWord: String
}

struct ChangeWordEntity {
    let targetWord: String
    let coins: Int
}

struct VerifyImageEntity {
    let isMatch: Bool
    let xpEarned: Int?
    let coinsEarned: Int?
    let level: Int?
    let levelProgressPercentage: Double?
}

struct GetHintEntity {
    let hint: String
    let coinsSpent: Int
    let remainingCoins: Int
}
