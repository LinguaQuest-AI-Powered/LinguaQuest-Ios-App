//
//  WordCardEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

struct WordCardEntity: Identifiable {
    let id: String
    let sourceWord: String
    let translatedWord: String
    let sourceLanguage: String
    let targetLanguage: String
    let category: String
    let imagePath: String
}
