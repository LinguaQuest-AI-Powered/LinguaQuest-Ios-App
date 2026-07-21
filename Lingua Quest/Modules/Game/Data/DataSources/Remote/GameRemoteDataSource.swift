//
//  GameRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

protocol GameRemoteDataSourceProtocol {
    func getLevels(worldId: Int, languageId: Int) async throws -> GameLevelsResponseDTO
}

struct GameRemoteDataSource: GameRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getLevels(worldId: Int, languageId: Int) async throws -> GameLevelsResponseDTO {
        let endpoint = GameEndpoint.Levels(worldId: worldId, languageId: languageId)
        return try await apiClient.request(endpoint)
    }
}
