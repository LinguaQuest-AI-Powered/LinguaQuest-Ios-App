//
//  VocabularyWordEntity.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

struct VocabularyWordEntity: Identifiable, Hashable {
    let id: UUID
    let word: String
    let meaning: String
    let exampleSentence: String
    let difficulty: String
    let sourceLanguage: String
    let targetLanguage: String
    let createdAt: Date
    let isShownOnLockScreen: Bool
    let shownAt: Date?
    let isAddedToJournal: Bool
}
