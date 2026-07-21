//
//  RegisterDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let email: String
    let username: String
    let password: String
    let nativeLanguage: String
    let targetLanguage: String
}

struct RegisterResponseDataDTO: Decodable {
    let id: Int
    let email: String
    let username: String
    let nativeLanguage: String
    let targetLanguage: String
    let isVerified: Bool
}
