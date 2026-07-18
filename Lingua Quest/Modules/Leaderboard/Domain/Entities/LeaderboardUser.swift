//
//  LeaderboardUser.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import Foundation

struct LeaderboardUser: Identifiable {
    let id: String
    let rank: Int
    let name: String
    let title: String
    let image : String
    let xp: Int
    let avatarName: String
    let isCurrentUser: Bool
}
