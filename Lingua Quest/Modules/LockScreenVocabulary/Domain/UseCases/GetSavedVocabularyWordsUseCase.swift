//
//  GetSavedVocabularyWordsUseCase.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol GetSavedVocabularyWordsUseCaseProtocol {
    func execute() async throws -> [VocabularyWordEntity]
}

final class GetSavedVocabularyWordsUseCase: GetSavedVocabularyWordsUseCaseProtocol {
    private let repository: VocabularyRepositoryProtocol
    private let userPreferences: UserPreferencesProtocol
    
    init(repository: VocabularyRepositoryProtocol, userPreferences: UserPreferencesProtocol) {
        self.repository = repository
        self.userPreferences = userPreferences
    }
    
    func execute() async throws -> [VocabularyWordEntity] {
        let words = try await repository.fetchSavedWords()
        let currentLang = userPreferences.targetLanguageName ?? "English"
        return words.filter { $0.targetLanguage == currentLang }
    }
}
