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
    
    var items: [CapturedItem] = []
    
    init(getCapturedItemsUseCase: GetCapturedItemsUseCase, saveCapturedItemUseCase: SaveCapturedItemUseCase, router: RouterProtocol) {
        self.getCapturedItemsUseCase = getCapturedItemsUseCase
        self.saveCapturedItemUseCase = saveCapturedItemUseCase
        self.router = router
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
