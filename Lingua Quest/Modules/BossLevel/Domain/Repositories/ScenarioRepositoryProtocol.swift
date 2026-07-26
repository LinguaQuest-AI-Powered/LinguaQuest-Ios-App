//
//  ScenarioRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

protocol ScenarioRepositoryProtocol {
    func getScenario(id: String) async throws -> BossScenario
    func getAllScenarios() async throws -> [BossScenario]
}
