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
}
