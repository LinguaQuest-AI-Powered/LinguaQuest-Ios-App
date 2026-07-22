//
//  ProfileDTO.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let success: Bool
    let data: ProfileDataDTO
}

struct ProfileDataDTO: Decodable {
    let id: Int
    let email: String
    let username: String?
    let nativeLanguage: String?
    let photoUrl: String?
    let level: Int?
    let stats: ProfileStatsDTO?
    let currentLanguageJourney: ProfileJourneyDTO?
    let achievementsSummary: ProfileAchievementsSummaryDTO?
    let leaderboardSummary: ProfileLeaderboardSummaryDTO?
}

struct ProfileStatsDTO: Decodable {
    let coins: Int
    let totalXp: Int
    let streakDays: Int
    let worldsCount: Int
}

struct ProfileJourneyDTO: Decodable {
    let languageId: Int
    let name: String
    let code: String
    let level: Int
    let journeyLabel: String
    let currentXp: Int
    let nextMilestoneXp: Int
}

struct ProfileAchievementsSummaryDTO: Decodable {
    let earnedCount: Int
    let totalCount: Int
    let preview: [ProfileAchievementPreviewDTO]
}

struct ProfileAchievementPreviewDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let iconUrl: String?
    let status: String
    let progressPercent: Int
}

struct ProfileLeaderboardSummaryDTO: Decodable {
    let myRank: Int
    let preview: [ProfileLeaderboardPreviewDTO]
}

struct ProfileLeaderboardPreviewDTO: Decodable {
    let rank: Int
    let userId: Int
    let username: String
    let photoUrl: String?
    let level: Int
    let xp: Int
    let isCurrentUser: Bool
}
