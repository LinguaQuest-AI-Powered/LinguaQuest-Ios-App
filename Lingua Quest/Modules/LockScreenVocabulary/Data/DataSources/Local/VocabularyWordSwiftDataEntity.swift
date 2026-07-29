//
//  VocabularyWordSwiftDataEntity.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation
import SwiftData

@Model
final class VocabularyWordSwiftDataEntity {
    @Attribute(.unique) var id: UUID
    var word: String
    var meaning: String
    var exampleSentence: String
    var difficulty: String
    var sourceLanguage: String
    var targetLanguage: String
    var createdAt: Date
    var isShownOnLockScreen: Bool = false
    var shownAt: Date?
    var isAddedToJournal: Bool = false
    var userId: Int
    
    
    init(id: UUID = UUID(), word: String, meaning: String, exampleSentence: String, difficulty: String, sourceLanguage: String, targetLanguage: String, createdAt: Date = Date(), isShownOnLockScreen: Bool = false, shownAt: Date? = nil, isAddedToJournal: Bool = false, userId: Int = 0) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.exampleSentence = exampleSentence
        self.difficulty = difficulty
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.createdAt = createdAt
        self.isShownOnLockScreen = isShownOnLockScreen
        self.shownAt = shownAt
        self.isAddedToJournal = isAddedToJournal
        self.userId = userId
    }
}
