//
//  LoginDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct LoginResponseDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let user: UserDTO
}

struct UserDTO: Decodable {
    let id: Int
    let username: String
    let photo: String?
    let nativeLanguage: String
    let isVerified: Bool
    let targetLanguages: [String]
}
