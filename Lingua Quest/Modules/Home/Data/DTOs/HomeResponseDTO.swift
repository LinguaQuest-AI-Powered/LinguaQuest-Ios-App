//
//  HomeResponseDTO.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let success: Bool
    let data: HomeDataContentDTO
    let activeLanguage: ActiveLanguageDTO
}

struct HomeDataContentDTO: Decodable {
    let xp: Int
    let coins: Int
    let streakDays: Int
}

struct ActiveLanguageDTO: Decodable {
    let id: Int
    let name: String
    let code: String
    let imageUrl: String
    let level: Int
    let levelProgressPercent: Int
    let exploreWorlds: [ExploreWorldDTO]
}

struct ExploreWorldDTO: Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let difficulty: String
    let status: String?
    let progressPercent: Int
    let totalLevels: Int
    let completedLevels: Int
}

struct WorldsResponseDTO: Decodable {
    let success: Bool
    let data: WorldsDataDTO
}

struct WorldsDataDTO: Decodable {
    let totalCount: Int
    let worlds: [ExploreWorldDTO]
}

struct DailyRewardResponseDTO: Decodable {
    let success: Bool
    let data: DailyRewardDataDTO
}

struct DailyRewardDataDTO: Decodable {
    let claimedToday: Bool
    let currentDay: Int
    let cycleLength: Int
    let rewardCoins: Int
    let rewardXp: Int?
    let streakDays: Int
}

struct DailyRewardClaimResponseDTO: Decodable {
    let success: Bool
    let data: DailyRewardClaimDataDTO
}

struct DailyRewardClaimDataDTO: Decodable {
    let coinsAwarded: Int
    let xpAwarded: Int?
    let newCoinsBalance: Int
    let newXpBalance: Int
    let newStreakDays: Int
    let nextDay: Int
}

// MARK: - Mappers
extension HomeResponseDTO {
    func toDomain() -> HomeData {
        return HomeData(
            xp: data.xp,
            coins: data.coins,
            streakDays: data.streakDays,
            activeLanguage: ActiveLanguage(
                id: activeLanguage.id,
                name: activeLanguage.name,
                code: activeLanguage.code,
                imageUrl: activeLanguage.imageUrl,
                level: activeLanguage.level,
                levelProgressPercent: activeLanguage.levelProgressPercent,
                exploreWorlds: activeLanguage.exploreWorlds.map { $0.toDomain() }
            )
        )
    }
}

extension ExploreWorldDTO {
    func toDomain() -> ExploreWorld {
        return ExploreWorld(
            id: id,
            name: name,
            imageUrl: imageUrl ?? "",
            difficulty: difficulty,
            status: status ?? "UNLOCKED",
            progressPercent: progressPercent,
            totalLevels: totalLevels,
            completedLevels: completedLevels
        )
    }
}

extension DailyRewardDataDTO {
    func toDomain() -> DailyRewardEntity {
        return DailyRewardEntity(
            claimedToday: claimedToday,
            currentDay: currentDay,
            cycleLength: cycleLength,
            rewardCoins: rewardCoins,
            rewardXp: rewardXp,
            streakDays: streakDays
        )
    }
}

extension DailyRewardClaimDataDTO {
    func toDomain() -> DailyRewardClaimEntity {
        return DailyRewardClaimEntity(
            coinsAwarded: coinsAwarded,
            xpAwarded: xpAwarded,
            newCoinsBalance: newCoinsBalance,
            newXpBalance: newXpBalance,
            newStreakDays: newStreakDays,
            nextDay: nextDay
        )
    }
}
