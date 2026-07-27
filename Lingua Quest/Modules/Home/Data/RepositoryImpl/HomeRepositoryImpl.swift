//
//  HomeRepositoryImpl.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

struct HomeRepositoryImpl: HomeRepositoryProtocol {
    private let remoteDataSource: HomeRemoteDataSourceProtocol
    private let localDataSource: HomeLocalDataSourceProtocol

    init(remoteDataSource: HomeRemoteDataSourceProtocol, localDataSource: HomeLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getHomeData() async throws -> HomeData {
        if let cached = localDataSource.homeData {
            return cached
        }
        let response = try await remoteDataSource.getHomeData()
        let domain = response.toDomain()
        localDataSource.homeData = domain
        return domain
    }
    
    func getWorlds(languageId: Int, difficulty: String?) async throws -> [ExploreWorld] {
        if let cached = localDataSource.getWorlds(languageId: languageId, difficulty: difficulty) {
            return cached
        }
        let response = try await remoteDataSource.getWorlds(languageId: languageId, difficulty: difficulty)
        let domain = response.data.worlds.map { $0.toDomain() }
        localDataSource.saveWorlds(domain, languageId: languageId, difficulty: difficulty)
        return domain
    }
    
    func getDailyReward() async throws -> DailyRewardEntity {
        if let cached = localDataSource.dailyReward {
            return cached
        }
        let response = try await remoteDataSource.getDailyReward()
        let domain = response.data.toDomain()
        localDataSource.dailyReward = domain
        return domain
    }
    
    func claimDailyReward() async throws -> DailyRewardClaimEntity {
        let response = try await remoteDataSource.claimDailyReward()
        let claimResult = response.data.toDomain()
        
        // Update the cached reward if it exists
        if let currentReward = localDataSource.dailyReward {
            localDataSource.dailyReward = DailyRewardEntity(
                claimedToday: true,
                currentDay: currentReward.currentDay,
                cycleLength: currentReward.cycleLength,
                rewardCoins: claimResult.coinsAwarded,
                rewardXp: claimResult.xpAwarded,
                streakDays: claimResult.newStreakDays
            )
        }
        return claimResult
    }
    
    func getMyLanguages() async throws -> [MyTargetLanguage] {
        if let cached = localDataSource.myLanguages {
            return cached
        }
        let response = try await remoteDataSource.getMyLanguages()
        let domain = response.data.languages.map { $0.toDomain() }
        localDataSource.myLanguages = domain
        return domain
    }
    
    func getAvailableLanguages() async throws -> [AvailableLanguage] {
        if let cached = localDataSource.availableLanguages {
            return cached
        }
        let response = try await remoteDataSource.getAvailableLanguages()
        let domain = response.data.languages.map { $0.toDomain() }
        localDataSource.availableLanguages = domain
        return domain
    }
    
    func switchActiveLanguage(languageId: Int) async throws -> MyTargetLanguage {
        let response = try await remoteDataSource.switchActiveLanguage(languageId: languageId)
        let activeLang = response.data.activeLanguage.toDomain()
        
        // Invalidate HomeData since the language switched, we need fresh progress/worlds
        localDataSource.homeData = nil
        // Or we could update the active flag in the cached languages list
        if var cached = localDataSource.myLanguages {
            for i in cached.indices {
                cached[i] = MyTargetLanguage(
                    id: cached[i].id,
                    name: cached[i].name,
                    code: cached[i].code,
                    level: cached[i].level,
                    isActive: cached[i].id == languageId,
                    progressPercent: cached[i].progressPercent
                )
            }
            localDataSource.myLanguages = cached
        }
        return activeLang
    }
    
    func addLanguages(languageIds: [Int]) async throws -> [MyTargetLanguage] {
        let response = try await remoteDataSource.addLanguages(languageIds: languageIds)
        let domain = response.data.languages.map { $0.toDomain() }
        // We probably added new languages, let's just invalidate the cache
        localDataSource.myLanguages = nil
        localDataSource.availableLanguages = nil
        return domain
    }
}
