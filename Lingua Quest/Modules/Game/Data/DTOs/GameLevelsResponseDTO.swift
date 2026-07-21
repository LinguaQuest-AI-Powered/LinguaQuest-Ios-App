//
//  GameLevelsResponseDTO.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

struct GameLevelsResponseDTO: Decodable {
    let success: Bool
    let data: WorldLevelsDTO
}

struct WorldLevelsDTO: Decodable {
    let id: Int
    let name: String
    let difficulty: String
    let levels: [GameLevelDTO]
}

struct GameLevelDTO: Decodable {
    let id: Int
    let order: Int
    let status: String
    let word: String?
}
