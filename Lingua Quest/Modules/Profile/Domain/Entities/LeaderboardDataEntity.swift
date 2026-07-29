//
//  LeaderboardDataEntity.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

struct LeaderboardDataEntity {
    let myRank: Int
    let topThree: [LeaderboardUserEntity]
    let entries: [LeaderboardUserEntity]
    let hasMore: Bool
}

struct LeaderboardUserEntity {
    let id: String
    let rank: Int
    let name: String
    let title: String
    let avatarImage: String?
    let xp: Int
    let isCurrentUser: Bool
}
