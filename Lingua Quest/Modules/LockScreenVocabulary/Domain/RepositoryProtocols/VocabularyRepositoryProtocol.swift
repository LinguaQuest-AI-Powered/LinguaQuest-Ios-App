//
//  VocabularyRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol VocabularyRepositoryProtocol {
    func fetchSavedWords() async throws -> [VocabularyWordEntity]
    func generateAndSaveWords(targetLanguage: String, count: Int, excludeWords: [String]?) async throws -> [VocabularyWordEntity]
    func markWordAsShown(id: UUID) async throws
    func markWordAsAddedToJournal(id: UUID) async throws
}
