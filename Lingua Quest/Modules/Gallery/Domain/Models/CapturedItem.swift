//
//  CapturedItem.swift
//  Lingua Quest
//

import Foundation

struct CapturedItem: Identifiable, Hashable {
    let id = UUID()
    let englishName: String
    let translatedName: String
    let category: String
    let image : String
    let isCollected: Bool
    
    
    static let mocks: [CapturedItem] = [
        CapturedItem(englishName: "Apple", translatedName: "La Manzana", category: "KITCHEN", image: "apple", isCollected: true),
        CapturedItem(englishName: "Table", translatedName: "La Mesa", category: "PARK", image: "table", isCollected: true),
        CapturedItem(englishName: "Leaf", translatedName: "La Hoja", category: "PARK", image: "leaf", isCollected: true),
        CapturedItem(englishName: "Cup", translatedName: "La Taza", category: "KITCHEN", image: "cup", isCollected: false),
        CapturedItem(englishName: "Bicycle", translatedName: "La Bicicleta", category: "STREET", image: "bicycle", isCollected: true),
        CapturedItem(englishName: "Dog", translatedName: "El Perro", category: "PARK", image: "dog", isCollected: true)
    ]
}
