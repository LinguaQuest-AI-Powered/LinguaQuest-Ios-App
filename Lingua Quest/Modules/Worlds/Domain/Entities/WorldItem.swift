//
//  WorldItem.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import Foundation

struct WorldItem: Identifiable {
    let id: String
    let title: String
    let imageAssetName: String
    let difficulty: WorldDifficulty
    let progress: Double
    let isCompleted: Bool
    var unlockLevel: Int? = nil
    
    var isLocked: Bool { unlockLevel != nil }
}
