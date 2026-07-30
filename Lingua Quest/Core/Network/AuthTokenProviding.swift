//
//  AuthTokenProviding.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

/// Lives in Core so APIClient can depend on it without knowing about the Auth module.
/// The concrete implementation (AuthTokenProvider) lives in Modules/Auth/Data.
protocol AuthTokenProviding: AnyObject {
    func currentAccessToken() -> String?
    /// Attempts to refresh the session using the stored refresh token.
    /// Returns true if a new access token is now available, false if the session is unrecoverable.
    func refreshSession() async -> Bool
}

