//
//  GameLevelsViewModel.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class GameLevelsViewModel {
    var levels: [GameLevel] = []
    
    init() {
        // Generate 30 levels for testing scrolling
        levels = (1...30).map { id in
            let status: LevelStatus
            if id < 3 {
                status = .completed(stars: 3)
            } else if id == 3 {
                status = .completed(stars: 2)
            } else if id == 4 {
                status = .unlocked
            } else {
                status = .locked
            }
            return GameLevel(id: id, status: status)
        }
        // Reverse so that level 1 is at the bottom of our ScrollView array if needed,
        // but we'll actually layout from bottom to top in the view by calculating y position.
    }
}
