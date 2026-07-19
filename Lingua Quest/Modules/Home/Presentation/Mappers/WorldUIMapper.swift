//
//  WorldUIMapper.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

/// Shared mapper from the pure Domain WorldItem to a display-ready WorldUIModel.
/// Kept as a standalone mapper (not a private method inside one ViewModel)
enum WorldUIMapper {
    static func map(_ entity: WorldItem) -> WorldUIModel {
        WorldUIModel(
            id: entity.id,
            title: entity.title,
            uiImage: Image.Asset(rawValue: entity.imageAssetName) ?? .kitchen,
            difficulty: entity.difficulty,
            uiDifficultyLabel: label(for: entity.difficulty),
            uiBadgeColor: badgeColor(for: entity.difficulty),
            progress: entity.progress,
            isCompleted: entity.isCompleted,
            isLocked: entity.isLocked,
            unlockLevel: entity.unlockLevel
        )
    }
    
    /// Exposed (not private) so filter UI can render a label/color for a
    /// WorldDifficulty case without needing a full WorldItem instance
    static func label(for difficulty: WorldDifficulty) -> String {
        switch difficulty {
        case .easy: return L10n.Home.difficultyEasy
        case .medium: return L10n.Home.difficultyMedium
        case .hard: return L10n.Home.difficultyHard
        }
    }
    
    static func badgeColor(for difficulty: WorldDifficulty) -> Color {
        switch difficulty {
        case .easy: return .appSemanticSuccess
        case .medium: return .appAccentOrange
        case .hard: return .appAccentStreakRed
        }
    }
}
