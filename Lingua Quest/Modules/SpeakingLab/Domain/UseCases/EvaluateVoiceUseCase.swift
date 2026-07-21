//
//  EvaluateVoiceUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class EvaluateVoiceUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(audioData: Data, targetText: String) async throws -> VoiceEvaluationResult {
        return try await repository.evaluateAudio(audioData: audioData, targetText: targetText)
    }
}
