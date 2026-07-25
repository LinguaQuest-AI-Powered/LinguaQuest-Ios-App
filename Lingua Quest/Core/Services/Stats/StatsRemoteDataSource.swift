//
//  StatsRemoteDataSource.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 25/07/2026.
//

import Foundation

protocol StatsRemoteDataSourceProtocol {
    func getWallet() async throws -> WalletResponseDTO
    func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws -> AdjustWalletResponseDTO
}

struct StatsRemoteDataSource: StatsRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getWallet() async throws -> WalletResponseDTO {
        let endpoint = WalletEndpoint.GetWallet()
        return try await apiClient.request(endpoint)
    }
    
    func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws -> AdjustWalletResponseDTO {
        let endpoint = WalletEndpoint.AdjustWallet(xpDelta: xpDelta, coinsDelta: coinsDelta)
        return try await apiClient.request(endpoint)
    }
}
