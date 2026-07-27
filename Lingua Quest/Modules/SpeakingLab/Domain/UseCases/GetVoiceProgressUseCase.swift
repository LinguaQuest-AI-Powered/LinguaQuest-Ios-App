//
//  GetVoiceProgressUseCase.swift
//  Lingua Quest
//
//  Created by siam on 22/07/2026.
//

import Foundation

class GetVoiceProgressUseCase {
    private let repository: VoiceEvaluationRepositoryProtocol
    private let userPreferences: UserPreferencesProtocol
    
    init(repository: VoiceEvaluationRepositoryProtocol, userPreferences: UserPreferencesProtocol) {
        self.repository = repository
        self.userPreferences = userPreferences
    }
    
    func execute() async throws -> (completed: Int, total: Int) {
        let langCode = userPreferences.learningLanguageCode ?? "en"
        return try await repository.getProgress(languageCode: langCode)
    }
}
