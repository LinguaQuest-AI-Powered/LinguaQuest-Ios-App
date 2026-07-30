//
//  HomeRemoteDataSource.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func getHomeData() async throws -> HomeResponseDTO
    func getWorlds(languageId: Int, difficulty: String?) async throws -> WorldsResponseDTO
    func getDailyReward() async throws -> DailyRewardResponseDTO
    func claimDailyReward() async throws -> DailyRewardClaimResponseDTO
    
    func getMyLanguages() async throws -> MyLanguagesResponseDTO
    func getAvailableLanguages() async throws -> AvailableLanguagesResponseDTO
    func switchActiveLanguage(languageId: Int) async throws -> SwitchActiveLanguageResponseDTO
    func addLanguages(languageIds: [Int]) async throws -> MyLanguagesResponseDTO
    func changeNativeLanguage(languageId: Int) async throws
}

struct HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getHomeData() async throws -> HomeResponseDTO {
        let endpoint = HomeEndpoint.GetHomeData()
        return try await apiClient.request(endpoint)
    }
    
    func getWorlds(languageId: Int, difficulty: String?) async throws -> WorldsResponseDTO {
        let endpoint = HomeEndpoint.GetWorlds(languageId: languageId, difficulty: difficulty)
        return try await apiClient.request(endpoint)
    }
    
    func getDailyReward() async throws -> DailyRewardResponseDTO {
        let endpoint = HomeEndpoint.GetDailyReward()
        return try await apiClient.request(endpoint)
    }
    
    func claimDailyReward() async throws -> DailyRewardClaimResponseDTO {
        let endpoint = HomeEndpoint.ClaimDailyReward()
        return try await apiClient.request(endpoint)
    }
    
    func getMyLanguages() async throws -> MyLanguagesResponseDTO {
        let endpoint = LanguageEndpoint.GetMyLanguages()
        return try await apiClient.request(endpoint)
    }
    
    func getAvailableLanguages() async throws -> AvailableLanguagesResponseDTO {
        let endpoint = LanguageEndpoint.GetAvailableLanguages()
        return try await apiClient.request(endpoint)
    }
    
    func switchActiveLanguage(languageId: Int) async throws -> SwitchActiveLanguageResponseDTO {
        let endpoint = LanguageEndpoint.SwitchActiveLanguage(languageId: languageId)
        return try await apiClient.request(endpoint)
    }
    
    func addLanguages(languageIds: [Int]) async throws -> MyLanguagesResponseDTO {
        let endpoint = LanguageEndpoint.AddLanguage(languageIds: languageIds)
        return try await apiClient.request(endpoint)
    }
    
    func changeNativeLanguage(languageId: Int) async throws {
        let endpoint = LanguageEndpoint.ChangeNativeLanguage(languageId: languageId)
        _ = try await apiClient.request(endpoint) as ChangeNativeLanguageResponseDTO
    }
}
