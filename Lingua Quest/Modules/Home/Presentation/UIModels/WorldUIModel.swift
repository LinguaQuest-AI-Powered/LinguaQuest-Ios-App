//
//  WorldUIModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct WorldUIModel: Identifiable {
    let id: String
    let title: String
    let uiImage: Image.Asset
    let difficulty: WorldDifficulty
    let uiDifficultyLabel: String
    let uiBadgeColor: Color
    let progress: Double
    let isCompleted: Bool
    let isLocked: Bool
    let unlockLevel: Int?
}
