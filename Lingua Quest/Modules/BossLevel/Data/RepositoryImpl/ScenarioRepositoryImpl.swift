//
//  ScenarioRepositoryImpl.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

final class ScenarioRepositoryImpl: ScenarioRepositoryProtocol {
    private let localDataSource: ScenarioLocalDataSource
    
    init(localDataSource: ScenarioLocalDataSource = ScenarioLocalDataSource()) {
        self.localDataSource = localDataSource
    }
    
    func getScenario(id: String) async throws -> BossScenario {
        let scenarios = try localDataSource.loadScenarios()
        guard let scenario = scenarios.first(where: { $0.id == id }) else {
            throw NSError(domain: "ScenarioRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Scenario with ID \(id) not found."])
        }
        return scenario
    }
    
    func getAllScenarios() async throws -> [BossScenario] {
        return try localDataSource.loadScenarios()
    }
}
