//
//  DailyMissionEntities.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

struct DailyMissionWordEntity {
    let word: String
    let isSolved: Bool
}

struct DailyMissionResultEntity {
    let isMatch: Bool
    let xpEarned: Int
    let coinsEarned: Int
}
