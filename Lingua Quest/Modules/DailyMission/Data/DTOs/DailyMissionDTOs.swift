//
//  DailyMissionDTOs.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

struct GetMissionResponseDTO: Codable {
    let success: Bool
    let data: GetMissionDataDTO?
}

struct GetMissionDataDTO: Codable {
    let word: String
    let isSolved: Bool?
}

struct VerifyMissionResponseDTO: Codable {
    let success: Bool
    let data: VerifyMissionDataDTO?
}

struct VerifyMissionDataDTO: Codable {
    let isMatch: Bool
    let xpEarned: Int?
    let coinsEarned: Int?
}
