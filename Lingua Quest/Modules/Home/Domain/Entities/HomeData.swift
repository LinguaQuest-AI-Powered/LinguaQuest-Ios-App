//
//  HomeData.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

struct HomeData: Equatable {
    let xp: Int
    let coins: Int
    let streakDays: Int
    let activeLanguage: ActiveLanguage
    
    init(xp: Int, coins: Int, streakDays: Int, activeLanguage: ActiveLanguage) {
        self.xp = xp
        self.coins = coins
        self.streakDays = streakDays
        self.activeLanguage = activeLanguage
    }
}

struct ActiveLanguage: Equatable {
    let id: Int
    let name: String
    let code: String
    let level: Int
    let levelProgressPercent: Int
    let exploreWorlds: [ExploreWorld]
    
    init(id: Int, name: String, code: String, level: Int, levelProgressPercent: Int, exploreWorlds: [ExploreWorld]) {
        self.id = id
        self.name = name
        self.code = code
        self.level = level
        self.levelProgressPercent = levelProgressPercent
        self.exploreWorlds = exploreWorlds
    }
}

public struct ExploreWorld: Equatable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let difficulty: String
    public let status: String
    public let progressPercent: Int
    public let totalLevels: Int
    public let completedLevels: Int
    
    public init(id: Int, name: String, imageUrl: String, difficulty: String, status: String, progressPercent: Int, totalLevels: Int, completedLevels: Int) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.difficulty = difficulty
        self.status = status
        self.progressPercent = progressPercent
        self.totalLevels = totalLevels
        self.completedLevels = completedLevels
    }
}
