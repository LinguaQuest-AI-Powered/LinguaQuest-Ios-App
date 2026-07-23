//
//  ProfileRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> UserProfileEntity
    func uploadPhoto(imageData: Data, mimeType: String) async throws -> String
    func updateProfile(username: String) async throws -> String
}

