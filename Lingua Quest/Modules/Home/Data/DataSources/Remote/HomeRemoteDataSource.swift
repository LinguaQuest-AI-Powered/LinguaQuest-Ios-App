//
//  HomeRemoteDataSource.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func getHomeData() async throws -> HomeResponseDTO
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
}
