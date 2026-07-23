//
//  ProfileRemoteDataSource.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func fetchProfile() async throws -> ProfileResponseDTO
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> UploadPhotoResponseDTO
    func updateProfile(username: String) async throws -> UpdateProfileResponseDTO
}

final class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchProfile() async throws -> ProfileResponseDTO {
        return try await apiClient.request(ProfileEndpoint.getProfile)
    }
    
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> UploadPhotoResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let endpoint = ProfileEndpoint.uploadPhoto(data: imageData, mimeType: mimeType, boundary: boundary)
        return try await apiClient.request(endpoint)
    }
    
    func updateProfile(username: String) async throws -> UpdateProfileResponseDTO {
        return try await apiClient.request(ProfileEndpoint.updateProfile(username: username))
    }
}



