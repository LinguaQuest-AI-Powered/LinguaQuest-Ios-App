//
//  GetGameLevelsUseCase.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

struct GetGameLevelsUseCase {
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(worldId: Int) async throws -> [GameLevel] {
        return try await repository.getLevels(worldId: worldId)
    }
}
