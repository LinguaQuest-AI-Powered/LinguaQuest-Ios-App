//
//  WordCardEntity.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

struct WordCardEntity: Identifiable, Hashable {
    let id: String
    let sourceWord: String
    let translatedWord: String
    let sourceLanguage: String
    let targetLanguage: String
    let category: String
    let imagePath: String
    let imageData: Data?
    let imageAsset: String?
    
    init(id: String, sourceWord: String, translatedWord: String, sourceLanguage: String, targetLanguage: String, category: String, imagePath: String, imageData: Data? = nil, imageAsset: String? = nil) {
        self.id = id
        self.sourceWord = sourceWord
        self.translatedWord = translatedWord
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.category = category
        self.imagePath = imagePath
        self.imageData = imageData
        self.imageAsset = imageAsset
    }
}
