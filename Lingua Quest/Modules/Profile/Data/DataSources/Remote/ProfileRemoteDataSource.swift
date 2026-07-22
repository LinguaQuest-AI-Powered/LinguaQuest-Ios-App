//
//  ProfileRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func fetchProfile() async throws -> ProfileResponseDTO
    func completeProfile(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async throws -> SuccessResponseDTO<OAuthResponseDataDTO>
}

final class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchProfile() async throws -> ProfileResponseDTO {
        return try await apiClient.request(ProfileEndpoint.GetProfile())
    }
    
    func completeProfile(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async throws -> SuccessResponseDTO<OAuthResponseDataDTO> {
        return try await apiClient.request(
            ProfileEndpoint.CompleteProfile(
                nativeLanguageId: nativeLanguageId,
                targetLanguageId: targetLanguageId,
                username: username
            )
        )
    }
}
