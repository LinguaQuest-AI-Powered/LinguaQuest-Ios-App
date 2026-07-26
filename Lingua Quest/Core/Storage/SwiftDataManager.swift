//
//  SwiftDataManager.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let container: ModelContainer
    var context: ModelContext {
        container.mainContext
    }
    
    private init() {
        do {
            container = try ModelContainer(for: CapturedItemEntity.self, VocabularyWordSwiftDataEntity.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
}
