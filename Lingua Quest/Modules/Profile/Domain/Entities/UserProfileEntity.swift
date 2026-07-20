//
//  UserProfileEntity.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct UserProfileEntity {
    let id: String
    let username: String
    let nativeLanguage: String
    let avatarUrl: String?
    let level: Int
    
    let coins: Int
    let totalXp: Int
    let streakDays: Int
    let worldsCount: Int
    
    let currentLanguageName: String
    let currentLanguageCode: String
    let currentLanguageLevel: Int
    let journeyLabel: String
    let currentXp: Int
    let nextMilestoneXp: Int
    
    let achievementsCount: Int
    let totalAchievements: Int
    let achievements: [AchievementEntity]
    
    let topExplorers: [ExplorerEntity]
}
