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
        // Mock data roughly matching the provided screenshot
        // Offsets represent (x, y) relative to the center of the path/view
        // Proportional positions (0.0 to 1.0) relative to the background image
        // To perfectly align the nodes exactly in the middle of the road on all screens
        levels = [
            GameLevel(id: 5, status: .locked, proportionalPosition: CGPoint(x: 0.45, y: 0.23)),
            GameLevel(id: 4, status: .locked, proportionalPosition: CGPoint(x: 0.35, y: 0.38)),
            GameLevel(id: 3, status: .unlocked, proportionalPosition: CGPoint(x: 0.55, y: 0.54)),
            GameLevel(id: 2, status: .completed(stars: 2), proportionalPosition: CGPoint(x: 0.35, y: 0.70)),
            GameLevel(id: 1, status: .completed(stars: 3), proportionalPosition: CGPoint(x: 0.55, y: 0.85))
        ]
    }
}
