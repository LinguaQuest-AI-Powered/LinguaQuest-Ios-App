//
//  SecureTokenStorage.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//


import Foundation
import Security


/// Thin Keychain wrapper. Deliberately not using UserPreferences (UserDefaults-backed)
/// since tokens must never be stored in plist-backed storage.
final class SecureTokenStorage: SecureTokenStorageProtocol {
    private let service = "com.linguaquest.auth"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    var hasActiveSession: Bool {
        getRefreshToken() != nil
    }

    func saveSession(accessToken: String, refreshToken: String) {
        set(accessToken, for: accessTokenKey)
        set(refreshToken, for: refreshTokenKey)
    }

    func getAccessToken() -> String? {
        get(accessTokenKey)
    }

    func getRefreshToken() -> String? {
        get(refreshTokenKey)
    }

    func clearSession() {
        delete(accessTokenKey)
        delete(refreshTokenKey)
    }

    // MARK: - Keychain primitives
    private func set(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(attributes as CFDictionary, nil)
    }

    private func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
