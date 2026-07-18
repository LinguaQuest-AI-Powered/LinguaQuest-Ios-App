//
//  ExplorerDomainModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import Foundation

struct ExplorerEntity: Identifiable {
    let id: String
    let rank: Int
    let name: String
    let xp: Int
    let avatarImage: String?
}
