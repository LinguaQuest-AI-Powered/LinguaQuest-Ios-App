//
//  GameFeatureDTOs.swift
//  Lingua Quest
//
//  Created by AI on 25/07/2026.
//

import Foundation

struct StartLevelResponseDTO: Codable {
    let success: Bool
    let data: StartLevelDataDTO
}

struct StartLevelDataDTO: Codable {
    let targetWord: String
}

struct ChangeWordResponseDTO: Codable {
    let success: Bool
    let data: ChangeWordDataDTO
}

struct ChangeWordDataDTO: Codable {
    let targetWord: String
    let coins: Int
}

struct VerifyImageResponseDTO: Codable {
    let success: Bool
    let data: VerifyImageDataDTO
}

struct VerifyImageDataDTO: Codable {
    let isMatch: Bool
    let xpEarned: Int?
    let coinsEarned: Int?
    let level: Int?
    let levelProgressPercentage: Double?
}

struct GetHintResponseDTO: Codable {
    let success: Bool
    let data: GetHintDataDTO
}

struct GetHintDataDTO: Codable {
    let hint: String
    let coinsSpent: Int
    let remainingCoins: Int
}
