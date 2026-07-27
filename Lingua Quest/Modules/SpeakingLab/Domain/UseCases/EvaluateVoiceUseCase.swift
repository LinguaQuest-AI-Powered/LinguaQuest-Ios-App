//
//  EvaluateVoiceUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class EvaluateVoiceUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    private let userPreferences: UserPreferencesProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol, userPreferences: UserPreferencesProtocol) {
        self.repository = repository
        self.userPreferences = userPreferences
    }
    
    func execute(audioData: Data, targetText: String) async throws -> VoiceEvaluationResult {
        let langCode = userPreferences.learningLanguageCode ?? "en"
        return try await repository.evaluateAudio(audioData: audioData, targetText: targetText, languageCode: langCode)
    }
}
