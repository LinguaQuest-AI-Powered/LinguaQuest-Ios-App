//
//  LeaderboardDTOs.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct LeaderboardResponseDTO: Decodable {
    let success: Bool
    let data: LeaderboardDataDTO
}

struct LeaderboardDataDTO: Decodable {
    let myRank: Int
    let topThree: [LeaderboardUserDTO]
    let entries: [LeaderboardUserDTO]
}

struct LeaderboardUserDTO: Decodable {
    let rank: Int
    let userId: Int
    let username: String
    let photoUrl: String?
    let level: Int
    let xp: Int
    let isCurrentUser: Bool
}
