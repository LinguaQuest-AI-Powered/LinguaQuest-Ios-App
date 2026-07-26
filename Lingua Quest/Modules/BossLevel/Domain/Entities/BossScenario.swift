//
//  BossScenario.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

struct BossScenario: Codable, Identifiable, Equatable {
    let id: String
    let worldId: String
    let bossName: String
    let roleDescription: String
    let objective: String
}
