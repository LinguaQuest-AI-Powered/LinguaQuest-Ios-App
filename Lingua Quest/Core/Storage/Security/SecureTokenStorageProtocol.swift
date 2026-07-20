//
//  SecureTokenStorageProtocol.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol SecureTokenStorageProtocol {
    func saveSession(accessToken: String, refreshToken: String)
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearSession()
    var hasActiveSession: Bool { get }
}
