//
//  StopBossLevelSessionUseCase.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

protocol StopBossLevelSessionUseCaseProtocol {
    func execute() async
}

final class StopBossLevelSessionUseCase: StopBossLevelSessionUseCaseProtocol {
    private let repository: BossLevelRepositoryProtocol
    
    init(repository: BossLevelRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async {
        await repository.stopSession()
    }
}
