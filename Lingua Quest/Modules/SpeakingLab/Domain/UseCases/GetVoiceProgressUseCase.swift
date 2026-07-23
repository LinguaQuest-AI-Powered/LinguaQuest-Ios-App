//
//  GetVoiceProgressUseCase.swift
//  Lingua Quest
//
//  Created by siam on 22/07/2026.
//

import Foundation

class GetVoiceProgressUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> (completed: Int, total: Int) {
        return try await repository.getProgress()
    }
}
