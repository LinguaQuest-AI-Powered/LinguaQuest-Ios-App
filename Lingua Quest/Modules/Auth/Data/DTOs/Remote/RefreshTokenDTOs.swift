//
//  RefreshTokenDTOs.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
}

struct RefreshTokenResponseDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
}
