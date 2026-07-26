//
//  MarkVocabularyWordAsShownUseCase.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import Foundation

protocol MarkVocabularyWordAsShownUseCaseProtocol {
    func execute(id: UUID) async throws
}

final class MarkVocabularyWordAsShownUseCase: MarkVocabularyWordAsShownUseCaseProtocol {
    private let repository: VocabularyRepositoryProtocol
    
    init(repository: VocabularyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws {
        try await repository.markWordAsShown(id: id)
    }
}
