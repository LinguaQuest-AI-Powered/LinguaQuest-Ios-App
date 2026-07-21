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
    let imageUrl: String
    let difficulty: String
    let status: String
    let progressPercent: Int
    let totalLevels: Int
    let completedLevels: Int
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
            imageUrl: imageUrl,
            difficulty: difficulty,
            status: status,
            progressPercent: progressPercent,
            totalLevels: totalLevels,
            completedLevels: completedLevels
        )
    }
}
