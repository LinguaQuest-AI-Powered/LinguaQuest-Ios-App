//
//  ProfileRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

final class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol

    init(remoteDataSource: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getProfile() async throws -> UserProfileEntity {
        let response = try await remoteDataSource.fetchProfile()
        let data = response.data
        
        let achievements: [AchievementEntity] = data.achievementsSummary?.preview.map { dto in
            let type: AchievementType = dto.name.contains("Wild Explorer") ? .wildExplorer : .perfectWeek
            return AchievementEntity(
                id: "\(dto.id)",
                title: dto.name,
                subtitle: dto.description,
                type: type
            )
        } ?? []
        
        let explorers: [ExplorerEntity] = data.leaderboardSummary?.preview.map { dto in
            ExplorerEntity(
                id: "\(dto.userId)",
                rank: dto.rank,
                name: dto.username,
                xp: dto.xp,
                avatarImage: dto.photoUrl,
                isCurrentUser: dto.isCurrentUser
            )
        } ?? []
        
        return UserProfileEntity(
            id: "\(data.id)",
            username: data.username ?? "User",
            nativeLanguage: data.nativeLanguage,
            avatarUrl: data.photoUrl,
            level: data.level ?? 1,
            coins: data.stats?.coins ?? 0,
            totalXp: data.stats?.totalXp ?? 0,
            streakDays: data.stats?.streakDays ?? 0,
            worldsCount: data.stats?.worldsCount ?? 0,
            currentLanguageName: data.currentLanguageJourney?.name ?? "",
            currentLanguageCode: data.currentLanguageJourney?.code ?? "",
            currentLanguageId: data.currentLanguageJourney?.languageId ?? 0,
            currentLanguageLevel: data.currentLanguageJourney?.level ?? 1,
            journeyLabel: data.currentLanguageJourney?.journeyLabel ?? "",
            currentXp: data.currentLanguageJourney?.currentXp ?? 0,
            nextMilestoneXp: data.currentLanguageJourney?.nextMilestoneXp ?? 100,
            achievementsCount: data.achievementsSummary?.earnedCount ?? 0,
            totalAchievements: data.achievementsSummary?.totalCount ?? 0,
            achievements: achievements,
            topExplorers: explorers
        )
    }
}
