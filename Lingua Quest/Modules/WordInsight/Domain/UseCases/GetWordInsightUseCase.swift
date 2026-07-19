//
//  GetWordInsightUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

protocol GetWordInsightUseCaseProtocol {
    func execute(for word: WordCardEntity) async -> Result<AIWordInsightEntity, WordInsightError>
}

final class GetWordInsightUseCase: GetWordInsightUseCaseProtocol {
    // MARK: - Properties
    private let repository: WordInsightRepositoryProtocol
    
    // MARK: - Init
    init(repository: WordInsightRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Execute
    func execute(for word: WordCardEntity) async -> Result<AIWordInsightEntity, WordInsightError> {
        await repository.getInsight(for: word)
    }
}
