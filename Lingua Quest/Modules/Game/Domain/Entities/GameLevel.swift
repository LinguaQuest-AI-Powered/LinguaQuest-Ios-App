//
//  GameLevel.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import Foundation

enum LevelStatus: Equatable {
    case locked
    case unlocked
    case completed(stars: Int)
}

struct GameLevel: Identifiable, Equatable {
    let id: Int
    let order: Int
    let status: LevelStatus
    let word: String?
}
