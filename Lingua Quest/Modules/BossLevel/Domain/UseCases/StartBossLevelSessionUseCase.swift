//
//  StartBossLevelSessionUseCase.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

protocol StartBossLevelSessionUseCaseProtocol {
    func execute(systemInstruction: String) async throws
}

final class StartBossLevelSessionUseCase: StartBossLevelSessionUseCaseProtocol {
    private let repository: BossLevelRepositoryProtocol
    
    init(repository: BossLevelRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(systemInstruction: String) async throws {
        try await repository.startSession(systemInstruction: systemInstruction)
    }
}
