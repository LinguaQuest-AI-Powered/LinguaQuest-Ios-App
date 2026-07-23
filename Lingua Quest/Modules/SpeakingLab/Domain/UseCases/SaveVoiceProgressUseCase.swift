//
//  SaveVoiceProgressUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class SaveVoiceProgressUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(sentenceId: String) async throws {
        try await repository.markSentenceCompleted(sentenceId: sentenceId)
    }
}
