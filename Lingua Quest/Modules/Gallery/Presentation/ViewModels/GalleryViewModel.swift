//
//  GalleryViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class GalleryViewModel {
    private let getCapturedItemsUseCase: GetCapturedItemsUseCase
    private let saveCapturedItemUseCase: SaveCapturedItemUseCase
    private let router: RouterProtocol
    private let userPreferences: UserPreferencesProtocol
    
    var items: [CapturedItem] = []
    
    init(getCapturedItemsUseCase: GetCapturedItemsUseCase, saveCapturedItemUseCase: SaveCapturedItemUseCase, router: RouterProtocol, userPreferences: UserPreferencesProtocol) {
        self.getCapturedItemsUseCase = getCapturedItemsUseCase
        self.saveCapturedItemUseCase = saveCapturedItemUseCase
        self.router = router
        self.userPreferences = userPreferences
    }
    
    func onWordTapped(_ item: CapturedItem) {
        let word = WordCardEntity(
            id: item.id.uuidString,
            sourceWord: item.englishName,
            translatedWord: item.translatedName,
            sourceLanguage: userPreferences.spokenLanguageCode ?? "en-US",
            targetLanguage: userPreferences.learningLanguageCode ?? "es-ES",
            category: item.category,
            imagePath: "",
            imageData: item.imageData,
            // Fallback to "apple" if no image data or asset exists (matching Gallery UI)
            imageAsset: item.image ?? (item.imageData == nil ? "apple" : nil)
        )
        router.push(.wordInsight(word: word))
    }
    
    func loadItems() {
        Task {
            do {
                let fetchedItems = try await getCapturedItemsUseCase.execute()
                self.items = fetchedItems
            } catch {
                print("Error loading captured items: \(error)")
            }
        }
    }
    
    // TEMPORARY DEBUG METHOD: Used to test SwiftData without wiring to the Game module
    func saveMockItem() {
        Task {
            let mockItem = CapturedItem(
                id: UUID(),
                englishName: "Mock Apple",
                translatedName: "La Manzana Mock",
                category: "DEBUG",
                imageData: nil, // Add logic to test real data if needed
                isCorrect: true,
                timestamp: Date(),
                image: "apple"
            )
            
            do {
                try await saveCapturedItemUseCase.execute(item: mockItem)
                loadItems() // Reload to see the new item
            } catch {
                print("Error saving mock item: \(error)")
            }
        }
    }
}
