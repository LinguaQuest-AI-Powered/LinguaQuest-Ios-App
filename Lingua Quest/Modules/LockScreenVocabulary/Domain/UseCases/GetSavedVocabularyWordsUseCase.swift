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
    
    init(repository: VocabularyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [VocabularyWordEntity] {
        try await repository.fetchSavedWords()
    }
}
