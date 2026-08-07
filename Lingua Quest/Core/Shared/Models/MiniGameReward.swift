//
//  MiniGameReward.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

enum MiniGameReward {
    case voiceGame
    case roleplay3Stars
    case roleplay2Stars
    case roleplay1Star
    
    var xp: Int {
        switch self {
        case .voiceGame: return 5
        case .roleplay3Stars: return 15
        case .roleplay2Stars: return 10
        case .roleplay1Star: return 5
        }
    }
    
    var coins: Int {
        switch self {
        case .voiceGame: return 1
        case .roleplay3Stars: return 3
        case .roleplay2Stars: return 2
        case .roleplay1Star: return 1
        }
    }
}
