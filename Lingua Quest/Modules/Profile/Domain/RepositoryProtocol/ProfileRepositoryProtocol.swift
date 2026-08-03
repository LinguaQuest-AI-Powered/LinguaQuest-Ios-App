//
//  ProfileRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> UserProfileEntity
    func completeProfile(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async throws -> (session: AuthSessionEntity, user: UserEntity, profileComplete: Bool)
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> String
    func updateProfile(username: String) async throws -> String
    
    // Achievements
    func getFullAchievements(status: String) async throws -> AchievementsDataEntity
    func getWeeklyReward() async throws -> WeeklyRewardEntity
    func claimWeeklyReward() async throws -> ClaimRewardResultEntity
    
    // Leaderboard
    func getLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity

    // Password
    func changePassword(oldPassword: String, newPassword: String) async throws
}

