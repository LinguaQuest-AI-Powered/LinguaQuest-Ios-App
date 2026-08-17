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
    let imageUrl: String?
    let uiImage: Image.Asset
    let difficulty: WorldDifficulty
    let uiDifficultyLabel: String
    let uiBadgeColor: Color
    let progress: Double
    let isCompleted: Bool
    let isLocked: Bool
    let unlockLevel: Int?
    
    init(
        id: String,
        title: String,
        imageUrl: String? = nil,
        uiImage: Image.Asset = .kitchen,
        difficulty: WorldDifficulty,
        uiDifficultyLabel: String,
        uiBadgeColor: Color,
        progress: Double,
        isCompleted: Bool,
        isLocked: Bool,
        unlockLevel: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.uiImage = uiImage
        self.difficulty = difficulty
        self.uiDifficultyLabel = uiDifficultyLabel
        self.uiBadgeColor = uiBadgeColor
        self.progress = progress
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.unlockLevel = unlockLevel
    }
}
