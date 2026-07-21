//
//  AchievementsRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

final class AchievementsRepositoryImpl: AchievementsRepositoryProtocol {
    private let remoteDataSource: AchievementsRemoteDataSourceProtocol

    init(remoteDataSource: AchievementsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getFullAchievements(status: String) async throws -> AchievementsDataEntity {
        let response = try await remoteDataSource.fetchAchievements(status: status)
        let data = response.data
        
        let mappedAchievements = data.achievements.map { dto in
                var fullIconUrl: String? = nil
                if let path = dto.iconUrl {
                    fullIconUrl = AppConfig.baseURL.appendingPathComponent(path.hasPrefix("/") ? String(path.dropFirst()) : path).absoluteString
                }
                
                return FullAchievementEntity(
                    id: "\(dto.id)",
                    title: dto.name,
                    subtitle: dto.description,
                    iconUrl: fullIconUrl,
                status: AchievementStatus(rawValue: dto.status) ?? .unknown,
                progressPercent: dto.progressPercent
            )
        }
        
        return AchievementsDataEntity(
            earnedCount: data.earnedCount,
            inProgressCount: data.inProgressCount,
            xpEarned: data.xpEarned,
            achievements: mappedAchievements
        )
    }

    func getWeeklyReward() async throws -> WeeklyRewardEntity {
        let response = try await remoteDataSource.getWeeklyReward()
        let data = response.data
        return WeeklyRewardEntity(
            claimedThisWeek: data.claimedThisWeek,
            rewardXp: data.rewardXp,
            rewardCoins: data.rewardCoins
        )
    }

    func claimWeeklyReward() async throws -> ClaimRewardResultEntity {
        let response = try await remoteDataSource.claimWeeklyReward()
        let data = response.data
        return ClaimRewardResultEntity(
            xpAwarded: data.xpAwarded,
            coinsAwarded: data.coinsAwarded,
            newXpBalance: data.newXpBalance,
            newCoinsBalance: data.newCoinsBalance
        )
    }
}
