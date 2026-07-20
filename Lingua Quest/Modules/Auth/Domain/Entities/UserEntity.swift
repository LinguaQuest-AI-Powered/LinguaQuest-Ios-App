//
//  UserEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Foundation

struct UserEntity: Identifiable {
    let id: Int
    let username: String
    let photo: String?
    let nativeLanguage: String
    let isVerified: Bool
    let targetLanguages: [String]
}
