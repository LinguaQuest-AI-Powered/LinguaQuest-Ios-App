//
//  HomeRepositoryImpl.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

struct HomeRepositoryImpl: HomeRepositoryProtocol {
    private let remoteDataSource: HomeRemoteDataSourceProtocol

    init(remoteDataSource: HomeRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getHomeData() async throws -> HomeData {
        let response = try await remoteDataSource.getHomeData()
        return response.toDomain()
    }
    
    func getWorlds(languageId: Int, difficulty: String?) async throws -> [ExploreWorld] {
        let response = try await remoteDataSource.getWorlds(languageId: languageId, difficulty: difficulty)
        return response.data.worlds.map { $0.toDomain() }
    }
    
    func getDailyReward() async throws -> DailyRewardEntity {
        let response = try await remoteDataSource.getDailyReward()
        return response.data.toDomain()
    }
    
    func claimDailyReward() async throws -> DailyRewardClaimEntity {
        let response = try await remoteDataSource.claimDailyReward()
        return response.data.toDomain()
    }
    
    func getMyLanguages() async throws -> [MyTargetLanguage] {
        let response = try await remoteDataSource.getMyLanguages()
        return response.data.languages.map { $0.toDomain() }
    }
    
    func getAvailableLanguages() async throws -> [AvailableLanguage] {
        let response = try await remoteDataSource.getAvailableLanguages()
        return response.data.languages.map { $0.toDomain() }
    }
    
    func switchActiveLanguage(languageId: Int) async throws -> MyTargetLanguage {
        let response = try await remoteDataSource.switchActiveLanguage(languageId: languageId)
        return response.data.activeLanguage.toDomain()
    }
    
    func addLanguages(languageIds: [Int]) async throws -> [MyTargetLanguage] {
        let response = try await remoteDataSource.addLanguages(languageIds: languageIds)
        return response.data.languages.map { $0.toDomain() }
    }
}
