//
//  VocabularyRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation
import SwiftData

@MainActor
final class VocabularyRepositoryImpl: VocabularyRepositoryProtocol {
    private let remoteDataSource: VocabularyRemoteDataSourceProtocol
    private let modelContext: ModelContext
    private let userPreferences: UserPreferencesProtocol
    
    init(remoteDataSource: VocabularyRemoteDataSourceProtocol, userPreferences: UserPreferencesProtocol) {
        self.remoteDataSource = remoteDataSource
        self.modelContext = SwiftDataManager.shared.context
        self.userPreferences = userPreferences
    }
    
    func fetchSavedWords() async throws -> [VocabularyWordEntity] {
        let currentUserId = userPreferences.userId ?? 0
        let descriptor = FetchDescriptor<VocabularyWordSwiftDataEntity>(
            predicate: #Predicate { $0.userId == currentUserId },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let savedModels = try modelContext.fetch(descriptor)
        
        return savedModels.map { model in
            VocabularyWordEntity(
                id: model.id,
                word: model.word,
                meaning: model.meaning,
                exampleSentence: model.exampleSentence,
                difficulty: model.difficulty,
                sourceLanguage: model.sourceLanguage,
                targetLanguage: model.targetLanguage,
                createdAt: model.createdAt,
                isShownOnLockScreen: model.isShownOnLockScreen,
                shownAt: model.shownAt,
                isAddedToJournal: model.isAddedToJournal
            )
        }
    }
    
    func generateAndSaveWords(targetLanguage: String, count: Int, excludeWords: [String]?) async throws -> [VocabularyWordEntity] {
        // Fetch from AI
        let dtos = try await remoteDataSource.generateVocabulary(targetLanguage: targetLanguage, count: count, excludeWords: excludeWords)
        
        var entities: [VocabularyWordEntity] = []
        
        for dto in dtos {
            let model = VocabularyWordSwiftDataEntity(
                word: dto.word,
                meaning: dto.meaning,
                exampleSentence: dto.exampleSentence,
                difficulty: dto.difficulty,
                sourceLanguage: "",
                targetLanguage: targetLanguage,
                isShownOnLockScreen: false,
                shownAt: nil,
                isAddedToJournal: false,
                userId: userPreferences.userId ?? 0
            )
            // Save to SwiftData
            modelContext.insert(model)
            
            // Map to domain entity
            let entity = VocabularyWordEntity(
                id: model.id,
                word: model.word,
                meaning: model.meaning,
                exampleSentence: model.exampleSentence,
                difficulty: model.difficulty,
                sourceLanguage: model.sourceLanguage,
                targetLanguage: model.targetLanguage,
                createdAt: model.createdAt,
                isShownOnLockScreen: model.isShownOnLockScreen,
                shownAt: model.shownAt,
                isAddedToJournal: model.isAddedToJournal
            )
            entities.append(entity)
        }
        
        try modelContext.save()
        return entities
    }
    
    func markWordAsShown(id: UUID) async throws {
        let currentUserId = userPreferences.userId ?? 0
        let descriptor = FetchDescriptor<VocabularyWordSwiftDataEntity>(predicate: #Predicate { $0.id == id && $0.userId == currentUserId })
        let savedModels = try modelContext.fetch(descriptor)
        if let model = savedModels.first {
            model.isShownOnLockScreen = true
            model.shownAt = Date()
            try modelContext.save()
        }
    }
    
    func markWordAsAddedToJournal(id: UUID) async throws {
        let currentUserId = userPreferences.userId ?? 0
        let descriptor = FetchDescriptor<VocabularyWordSwiftDataEntity>(predicate: #Predicate { $0.id == id && $0.userId == currentUserId })
        let savedModels = try modelContext.fetch(descriptor)
        if let model = savedModels.first {
            model.isAddedToJournal = true
            try modelContext.save()
        }
    }
}
