//
//  CapturedItemEntity.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation
import SwiftData

@Model
final class CapturedItemEntity {
    @Attribute(.unique) var id: UUID
    @Attribute(.externalStorage) var imageData: Data?
    var answer: String
    var targetWord: String
    var isCorrect: Bool
    var category: String
    var timestamp: Date
    var userId: Int
    
    
    init(id: UUID = UUID(), imageData: Data?, answer: String, targetWord: String, isCorrect: Bool, category: String, timestamp: Date = Date(), userId: Int = 0) {
        self.id = id
        self.imageData = imageData
        self.answer = answer
        self.targetWord = targetWord
        self.isCorrect = isCorrect
        self.category = category
        self.timestamp = timestamp
        self.userId = userId
    }
}
