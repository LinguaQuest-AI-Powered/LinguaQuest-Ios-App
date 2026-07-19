//
//  WordInsightRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

protocol WordInsightRepositoryProtocol {
    func getInsight(for word: WordCardEntity) async -> Result<AIWordInsightEntity, WordInsightError>
}
