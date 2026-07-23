//
//  ProfileRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

final class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol
    private let tokenStorage: SecureTokenStorageProtocol

    init(remoteDataSource: ProfileRemoteDataSourceProtocol, tokenStorage: SecureTokenStorageProtocol) {
        self.remoteDataSource = remoteDataSource
        self.tokenStorage = tokenStorage
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

    func completeProfile(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async throws -> (session: AuthSessionEntity, user: UserEntity, profileComplete: Bool) {
        do {
            let response = try await remoteDataSource.completeProfile(
                nativeLanguageId: nativeLanguageId,
                targetLanguageId: targetLanguageId,
                username: username
            )
            
            let result = AuthDTOMapper.mapOAuthLogin(response.data)
            
            // Save the new tokens!
            tokenStorage.saveSession(
                accessToken: result.session.accessToken,
                refreshToken: result.session.refreshToken
            )
            
            return result
        } catch {
            throw AuthDTOMapper.mapError(error)
        }
    }

    func uploadPhoto(imageData: Data, mimeType: String) async throws -> String {
        let response = try await remoteDataSource.uploadPhoto(imageData: imageData, mimeType: mimeType)
        return response.data.photoUrl
    }
    
    func updateProfile(username: String) async throws -> String {
        let response = try await remoteDataSource.updateProfile(username: username)
        return response.data.username
    }
    
    // MARK: - Achievements
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
    
    // MARK: - Leaderboard
    func getLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity {
        let response = try await remoteDataSource.fetchLeaderboard(scope: scope, languageId: languageId, page: page, limit: limit)
        let data = response.data
        
        let mapUser: (LeaderboardUserDTO) -> LeaderboardUserEntity = { dto in
            LeaderboardUserEntity(
                id: "\(dto.userId)",
                rank: dto.rank,
                name: dto.username,
                title: "Level \(dto.level)", // Provide a fallback title or map it appropriately
                avatarImage: dto.photoUrl,
                xp: dto.xp,
                isCurrentUser: dto.isCurrentUser
            )
        }
        
        let topThree = data.topThree.map(mapUser)
        let entries = data.entries.map(mapUser)
        
        return LeaderboardDataEntity(
            myRank: data.myRank,
            topThree: topThree,
            entries: entries
        )
    }
}

