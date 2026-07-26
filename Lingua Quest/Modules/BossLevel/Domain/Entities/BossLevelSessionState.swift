//
//  BossLevelSessionState.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

enum BossLevelConnectionStatus: Equatable {
    case disconnected
    case connecting
    case connected
    case error(String)
}

struct BossLevelSessionState: Equatable {
    var status: BossLevelConnectionStatus = .disconnected
    var isUserSpeaking: Bool = false
    var isAISpeaking: Bool = false
    var userAudioLevel: Float = 0.0
    var aiAudioLevel: Float = 0.0
}
