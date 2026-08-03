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
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> UploadPhotoResponseDTO
    func updateProfile(username: String) async throws -> UpdateProfileResponseDTO
    
    // Achievements
    func fetchAchievements(status: String) async throws -> AchievementsResponseDTO
    func getWeeklyReward() async throws -> WeeklyRewardResponseDTO
    func claimWeeklyReward() async throws -> ClaimRewardResponseDTO
    
    // Leaderboard
    func fetchLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardResponseDTO
    func changePassword(oldPassword: String, newPassword: String) async throws -> ChangePasswordResponseDTO
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
    
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> UploadPhotoResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let endpoint = ProfileEndpoint.uploadPhoto(data: imageData, mimeType: mimeType, boundary: boundary)
        return try await apiClient.request(endpoint)
    }
    
    func updateProfile(username: String) async throws -> UpdateProfileResponseDTO {
        return try await apiClient.request(ProfileEndpoint.updateProfile(username: username))
    }
    
    // MARK: - Achievements
    func fetchAchievements(status: String) async throws -> AchievementsResponseDTO {
        return try await apiClient.request(ProfileEndpoint.GetAchievements(status: status))
    }

    func getWeeklyReward() async throws -> WeeklyRewardResponseDTO {
        return try await apiClient.request(ProfileEndpoint.GetWeeklyReward())
    }

    func claimWeeklyReward() async throws -> ClaimRewardResponseDTO {
        return try await apiClient.request(ProfileEndpoint.ClaimWeeklyReward())
    }
    
    // MARK: - Leaderboard
    func fetchLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardResponseDTO {
        return try await apiClient.request(ProfileEndpoint.GetLeaderboard(scope: scope, languageId: languageId, page: page, limit: limit))
    }

    func changePassword(oldPassword: String, newPassword: String) async throws -> ChangePasswordResponseDTO {
        return try await apiClient.request(ProfileEndpoint.ChangePassword(oldPassword: oldPassword, newPassword: newPassword))
    }
}
