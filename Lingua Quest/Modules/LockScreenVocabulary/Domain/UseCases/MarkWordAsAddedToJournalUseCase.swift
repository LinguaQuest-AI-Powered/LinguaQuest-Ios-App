//
//  MarkWordAsAddedToJournalUseCase.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import Foundation

protocol MarkWordAsAddedToJournalUseCaseProtocol {
    func execute(id: UUID) async throws
}

struct MarkWordAsAddedToJournalUseCase: MarkWordAsAddedToJournalUseCaseProtocol {
    private let repository: VocabularyRepositoryProtocol
    
    init(repository: VocabularyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws {
        try await repository.markWordAsAddedToJournal(id: id)
    }
}
