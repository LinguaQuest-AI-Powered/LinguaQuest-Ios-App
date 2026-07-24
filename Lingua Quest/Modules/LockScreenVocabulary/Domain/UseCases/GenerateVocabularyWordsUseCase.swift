//
//  GenerateVocabularyWordsUseCase.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol GenerateVocabularyWordsUseCaseProtocol {
    func execute(targetLanguage: String, count: Int, excludeWords: [String]?) async throws -> [VocabularyWordEntity]
}

final class GenerateVocabularyWordsUseCase: GenerateVocabularyWordsUseCaseProtocol {
    private let repository: VocabularyRepositoryProtocol
    
    init(repository: VocabularyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(targetLanguage: String, count: Int, excludeWords: [String]? = nil) async throws -> [VocabularyWordEntity] {
        return try await repository.generateAndSaveWords(
            targetLanguage: targetLanguage,
            count: count,
            excludeWords: excludeWords
        )
    }
}
