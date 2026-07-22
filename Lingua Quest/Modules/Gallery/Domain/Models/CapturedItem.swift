//
//  CapturedItem.swift
//  Lingua Quest
//

import Foundation

struct CapturedItem: Identifiable, Hashable {
    let id: UUID
    let englishName: String
    let translatedName: String
    let category: String
    let imageData: Data?
    let isCorrect: Bool
    let timestamp: Date
    
    // For backwards compatibility and UI mocking
    var image: String?
    var isCollected: Bool { isCorrect }
    
    init(id: UUID = UUID(), englishName: String, translatedName: String, category: String, imageData: Data? = nil, isCorrect: Bool, timestamp: Date = Date(), image: String? = nil) {
        self.id = id
        self.englishName = englishName
        self.translatedName = translatedName
        self.category = category
        self.imageData = imageData
        self.isCorrect = isCorrect
        self.timestamp = timestamp
        self.image = image
    }
    
    static let mocks: [CapturedItem] = [
        CapturedItem(englishName: "Apple", translatedName: "La Manzana", category: "KITCHEN", isCorrect: true, image: "apple"),
        CapturedItem(englishName: "Table", translatedName: "La Mesa", category: "PARK", isCorrect: true, image: "table"),
        CapturedItem(englishName: "Leaf", translatedName: "La Hoja", category: "PARK", isCorrect: true, image: "leaf"),
        CapturedItem(englishName: "Cup", translatedName: "La Taza", category: "KITCHEN", isCorrect: false, image: "cup"),
        CapturedItem(englishName: "Bicycle", translatedName: "La Bicicleta", category: "STREET", isCorrect: true, image: "bicycle"),
        CapturedItem(englishName: "Dog", translatedName: "El Perro", category: "PARK", isCorrect: true, image: "dog")
    ]
}
