//
//  GameRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

protocol GameRemoteDataSourceProtocol {
    func getLevels(worldId: Int, languageId: Int) async throws -> GameLevelsResponseDTO
    func startLevel(worldId: Int, levelId: Int) async throws -> StartLevelResponseDTO
    func changeWord(worldId: Int, levelId: Int) async throws -> ChangeWordResponseDTO
    func verifyImage(worldId: Int, levelId: Int, imageData: Data) async throws -> VerifyImageResponseDTO
    func getHint(worldId: Int, levelId: Int) async throws -> GetHintResponseDTO
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
    
    func startLevel(worldId: Int, levelId: Int) async throws -> StartLevelResponseDTO {
        let endpoint = GameEndpoint.StartLevel(worldId: worldId, levelId: levelId)
        return try await apiClient.request(endpoint)
    }
    
    func changeWord(worldId: Int, levelId: Int) async throws -> ChangeWordResponseDTO {
        let endpoint = GameEndpoint.ChangeWord(worldId: worldId, levelId: levelId)
        return try await apiClient.request(endpoint)
    }
    
    func verifyImage(worldId: Int, levelId: Int, imageData: Data) async throws -> VerifyImageResponseDTO {
        let endpoint = GameEndpoint.VerifyImage(worldId: worldId, levelId: levelId, imageData: imageData)
        return try await apiClient.request(endpoint)
    }
    
    func getHint(worldId: Int, levelId: Int) async throws -> GetHintResponseDTO {
        let endpoint = GameEndpoint.GetHint(worldId: worldId, levelId: levelId)
        return try await apiClient.request(endpoint)
    }
}
