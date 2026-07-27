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
        let targetCode = userPreferences.learningLanguageCode ?? "en"
        let englishLocale = Locale(identifier: "en_US")
        let currentLang = englishLocale.localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
        return words.filter { $0.targetLanguage == currentLang }
    }
}
