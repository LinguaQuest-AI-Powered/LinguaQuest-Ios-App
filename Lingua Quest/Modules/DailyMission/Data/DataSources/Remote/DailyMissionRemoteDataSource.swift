//
//  DailyMissionRemoteDataSource.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

protocol DailyMissionRemoteDataSourceProtocol {
    func getMission() async throws -> GetMissionResponseDTO
    func verifyMission(imageData: Data, word: String) async throws -> VerifyMissionResponseDTO
}

struct DailyMissionRemoteDataSource: DailyMissionRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getMission() async throws -> GetMissionResponseDTO {
        let endpoint = DailyMissionEndpoint.GetMission()
        return try await apiClient.request(endpoint)
    }

    func verifyMission(imageData: Data, word: String) async throws -> VerifyMissionResponseDTO {
        let endpoint = DailyMissionEndpoint.VerifyMission(imageData: imageData, word: word)
        return try await apiClient.request(endpoint)
    }
}
