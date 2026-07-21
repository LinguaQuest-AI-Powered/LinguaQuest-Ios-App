//
//  ProfileRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func fetchProfile() async throws -> ProfileResponseDTO
}

final class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchProfile() async throws -> ProfileResponseDTO {
        return try await apiClient.request(ProfileEndpoint.getProfile)
    }
}
