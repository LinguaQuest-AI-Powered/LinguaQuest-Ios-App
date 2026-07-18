//
//  AIWordInsightEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

struct AIWordInsightEntity {
    let exampleSentence: String
    let sentenceTranslation: String
    let memoryTip: String
    let funFact: String
}

enum InsightSectionID: String, Identifiable {
    case sentence
    case translation
    case memory
    case funFact
    
    var id: String { rawValue }
}
