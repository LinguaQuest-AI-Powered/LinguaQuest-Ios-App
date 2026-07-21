//
//  LeaderboardRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol LeaderboardRemoteDataSourceProtocol {
    func fetchLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardResponseDTO
}

final class LeaderboardRemoteDataSource: LeaderboardRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardResponseDTO {
        return try await apiClient.request(LeaderboardEndpoint.getLeaderboard(scope: scope, languageId: languageId, page: page, limit: limit))
    }
}
