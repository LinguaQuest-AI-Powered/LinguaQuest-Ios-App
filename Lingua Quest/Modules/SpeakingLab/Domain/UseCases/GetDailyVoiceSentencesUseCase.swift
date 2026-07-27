//
//  GetDailyVoiceSentencesUseCase.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class GetDailyVoiceSentencesUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    private let userPreferences: UserPreferencesProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol, userPreferences: UserPreferencesProtocol) {
        self.repository = repository
        self.userPreferences = userPreferences
    }
    
    func execute() async throws -> [VoiceSentence] {
        let langName = userPreferences.targetLanguageName ?? "English"
        let langCode = userPreferences.learningLanguageCode ?? "en"
        return try await repository.getDailySentences(languageName: langName, languageCode: langCode)
    }
}
