//
//  GalleryRepositoryImpl.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation
import SwiftData

class GalleryRepositoryImpl: GalleryRepositoryProtocol {
    
    init() {
    }
    
    func getCapturedItems() async throws -> [CapturedItem] {
        let modelContext = await MainActor.run { SwiftDataManager.shared.context }
        let descriptor = FetchDescriptor<CapturedItemEntity>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        let entities = try modelContext.fetch(descriptor)
        
        return entities.map { entity in
            CapturedItem(
                id: entity.id,
                englishName: entity.answer, // Fallback if we use englishName in the UI
                translatedName: entity.targetWord,
                category: entity.category,
                imageData: entity.imageData,
                isCorrect: entity.isCorrect,
                timestamp: entity.timestamp
            )
        }
    }
    
    func saveCapturedItem(_ item: CapturedItem) async throws {
        let entity = CapturedItemEntity(
            id: item.id,
            imageData: item.imageData,
            answer: item.englishName, // Or whatever matches answer
            targetWord: item.translatedName, // Or whatever matches targetWord
            isCorrect: item.isCorrect,
            category: item.category,
            timestamp: item.timestamp
        )
        
        try await MainActor.run {
            let modelContext = SwiftDataManager.shared.context
            modelContext.insert(entity)
            try modelContext.save()
        }
    }
}
