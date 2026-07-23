//
//  WorldUIMapper.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

/// Shared mapper from the pure Domain ExploreWorld to a display-ready WorldUIModel.
/// Kept as a standalone mapper (not a private method inside one ViewModel)
enum WorldUIMapper {
    static func map(_ entity: ExploreWorld) -> WorldUIModel {
        let difficulty: WorldDifficulty = {
            switch entity.difficulty {
            case "EASY": return .easy
            case "MEDIUM": return .medium
            default: return .hard
            }
        }()
        
        let assetName = URL(fileURLWithPath: entity.imageUrl).deletingPathExtension().lastPathComponent
        
        return WorldUIModel(
            id: "\(entity.id)",
            title: entity.name,
            uiImage: Image.Asset(rawValue: assetName) ?? .kitchen,
            difficulty: difficulty,
            uiDifficultyLabel: label(for: difficulty),
            uiBadgeColor: badgeColor(for: difficulty),
            progress: Double(entity.progressPercent) / 100.0,
            isCompleted: entity.status == "COMPLETED",
            isLocked: entity.status == "LOCKED",
            unlockLevel: nil
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
