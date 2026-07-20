//
//  RegisteredAccountEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Foundation

/// Returned by POST /auth/register. Deliberately separate from UserEntity
/// because the register response shape differs (no photo/targetLanguages array,
/// single targetLanguage string, isVerified always false here).
struct RegisteredAccountEntity {
    let id: Int
    let email: String
    let username: String
    let nativeLanguage: String
    let targetLanguage: String
    let isVerified: Bool
}
