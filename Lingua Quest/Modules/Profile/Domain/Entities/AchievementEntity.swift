//
//  AchievementModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import Foundation

struct AchievementEntity: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let type: AchievementType
}

enum AchievementType: String {
    case wildExplorer
    case perfectWeek
}
