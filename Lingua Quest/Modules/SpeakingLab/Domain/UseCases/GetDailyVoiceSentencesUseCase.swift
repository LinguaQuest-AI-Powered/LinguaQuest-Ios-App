//
//  GetDailyVoiceSentencesUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class GetDailyVoiceSentencesUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [VoiceSentence] {
        return try await repository.getDailySentences()
    }
}
