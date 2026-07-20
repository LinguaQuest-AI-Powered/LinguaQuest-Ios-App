//
//  AuthSessionEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Foundation

/// Represents the tokens returned by login / refresh-token / oauth endpoints.
struct AuthSessionEntity {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
}
