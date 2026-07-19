//
//  WordInsightRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

final class WordInsightRepositoryImpl: WordInsightRepositoryProtocol {
    // MARK: - Properties
    private let remoteDataSource: WordInsightRemoteDataSourceProtocol
    
    // MARK: - Init
    init(remoteDataSource: WordInsightRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - API
    func getInsight(for word: WordCardEntity) async -> Result<AIWordInsightEntity, WordInsightError> {
        await remoteDataSource.getInsight(for: word)
    }
}
