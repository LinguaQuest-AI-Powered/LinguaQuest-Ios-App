//
//  AppSound.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 30/07/2026.
//

import Foundation

enum AppSound: String, CaseIterable {
    case success = "sound_success"
    case fail = "sound_fail"
    case camera = "sound_camera"
    case dailyReward = "sound_happy"
    case coin = "sound_coin"
    case pop = "sound_pop"
    case switchSound = "switch_sound"
    
    var volume: Float {
        switch self {
        case .success: return 0.6
        case .fail: return 0.5
        case .camera: return 0.3
        case .dailyReward: return 0.4
        case .coin: return 0.5
        case .pop: return 0.5
        case .switchSound: return 0.5
        }
    }
}
