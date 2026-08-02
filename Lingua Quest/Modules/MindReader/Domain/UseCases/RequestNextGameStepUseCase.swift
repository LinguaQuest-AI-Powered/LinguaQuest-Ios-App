//
//  RequestNextGameStepUseCase.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct RequestNextGameStepUseCase {
    let repository: MindReaderRepositoryProtocol
    
    func execute(category: GameCategory, history: [GameTurn]) async throws -> AIGameDecision {
        return try await repository.requestNextStep(category: category, history: history)
    }
}
