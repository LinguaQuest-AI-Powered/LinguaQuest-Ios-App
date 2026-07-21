//
//  AchievementsRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol AchievementsRemoteDataSourceProtocol {
    func fetchAchievements(status: String) async throws -> AchievementsResponseDTO
    func getWeeklyReward() async throws -> WeeklyRewardResponseDTO
    func claimWeeklyReward() async throws -> ClaimRewardResponseDTO
}

final class AchievementsRemoteDataSource: AchievementsRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchAchievements(status: String) async throws -> AchievementsResponseDTO {
        return try await apiClient.request(AchievementsEndpoint.getAchievements(status: status))
    }

    func getWeeklyReward() async throws -> WeeklyRewardResponseDTO {
        return try await apiClient.request(AchievementsEndpoint.getWeeklyReward)
    }

    func claimWeeklyReward() async throws -> ClaimRewardResponseDTO {
        return try await apiClient.request(AchievementsEndpoint.claimWeeklyReward)
    }
}
