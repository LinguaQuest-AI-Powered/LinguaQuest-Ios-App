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
            username: data.username,
            nativeLanguage: data.nativeLanguage,
            avatarUrl: data.photoUrl,
            level: data.level,
            coins: data.stats.coins,
            totalXp: data.stats.totalXp,
            streakDays: data.stats.streakDays,
            worldsCount: data.stats.worldsCount,
            currentLanguageName: data.currentLanguageJourney.name,
            currentLanguageCode: data.currentLanguageJourney.code,
            currentLanguageId: data.currentLanguageJourney.languageId,
            currentLanguageLevel: data.currentLanguageJourney.level,
            journeyLabel: data.currentLanguageJourney.journeyLabel,
            currentXp: data.currentLanguageJourney.currentXp,
            nextMilestoneXp: data.currentLanguageJourney.nextMilestoneXp,
            achievementsCount: data.achievementsSummary?.earnedCount ?? 0,
            totalAchievements: data.achievementsSummary?.totalCount ?? 0,
            achievements: achievements,
            topExplorers: explorers
        )
    }
}
