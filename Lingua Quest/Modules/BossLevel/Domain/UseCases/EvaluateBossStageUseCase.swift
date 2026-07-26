//
//  EvaluateBossStageUseCase.swift
//  Lingua Quest
//
//  Created by taqieallah on 25/07/2026.
//

import Foundation

protocol EvaluateBossStageUseCaseProtocol {
    func execute(scenario: BossScenario, transcript: String) async throws -> BossEvaluationResult
}

final class EvaluateBossStageUseCase: EvaluateBossStageUseCaseProtocol {
    private let repository: BossLevelRepositoryProtocol
    
    init(repository: BossLevelRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(scenario: BossScenario, transcript: String) async throws -> BossEvaluationResult {
        return try await repository.evaluateStage(scenario: scenario, transcript: transcript)
    }
}
