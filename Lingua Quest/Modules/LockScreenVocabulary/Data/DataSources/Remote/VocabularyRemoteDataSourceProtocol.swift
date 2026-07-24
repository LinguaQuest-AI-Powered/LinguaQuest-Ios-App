//
//  VocabularyRemoteDataSourceProtocol.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol VocabularyRemoteDataSourceProtocol {
    func generateVocabulary(targetLanguage: String, count: Int, excludeWords: [String]?) async throws -> [VocabularyWordDTO]
}
