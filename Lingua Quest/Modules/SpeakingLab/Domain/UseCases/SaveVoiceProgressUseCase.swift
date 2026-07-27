//
//  SaveVoiceProgressUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class SaveVoiceProgressUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    private let userPreferences: UserPreferencesProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol, userPreferences: UserPreferencesProtocol) {
        self.repository = repository
        self.userPreferences = userPreferences
    }
    
    func execute(sentenceId: String) async throws {
        let langCode = userPreferences.learningLanguageCode ?? "en"
        try await repository.markSentenceCompleted(sentenceId: sentenceId, languageCode: langCode)
    }
}
