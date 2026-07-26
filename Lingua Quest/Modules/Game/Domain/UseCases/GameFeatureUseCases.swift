//
//  GameFeatureUseCases.swift
//  Lingua Quest
//
//  Created by AI on 25/07/2026.
//

import Foundation

struct StartLevelUseCase {
    let repository: GameRepositoryProtocol
    
    func execute(worldId: Int, levelId: Int) async throws -> StartLevelEntity {
        try await repository.startLevel(worldId: worldId, levelId: levelId)
    }
}

struct ChangeWordUseCase {
    let repository: GameRepositoryProtocol
    
    func execute(worldId: Int, levelId: Int) async throws -> ChangeWordEntity {
        try await repository.changeWord(worldId: worldId, levelId: levelId)
    }
}

struct VerifyImageUseCase {
    let repository: GameRepositoryProtocol
    
    func execute(worldId: Int, levelId: Int, imageData: Data) async throws -> VerifyImageEntity {
        try await repository.verifyImage(worldId: worldId, levelId: levelId, imageData: imageData)
    }
}

struct GetHintUseCase {
    let repository: GameRepositoryProtocol
    
    func execute(worldId: Int, levelId: Int) async throws -> GetHintEntity {
        try await repository.getHint(worldId: worldId, levelId: levelId)
    }
}
