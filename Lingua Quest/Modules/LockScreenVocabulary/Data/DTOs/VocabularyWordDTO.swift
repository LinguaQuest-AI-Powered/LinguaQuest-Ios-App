//
//  VocabularyWordDTO.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct VocabularyWordDTO: Codable {
    let word: String
    let meaning: String
    let exampleSentence: String
    let difficulty: String
}

struct VocabularyGeneratorResponseDTO: Codable {
    let words: [VocabularyWordDTO]
}

struct VocabularyGeneratorRequestDTO: Encodable {
    let sourceLanguage: String
    let targetLanguage: String
    let count: Int
}
