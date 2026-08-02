//
//  MindReaderRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

protocol MindReaderRepositoryProtocol {
    func fetchCategories() -> [GameCategory]
    
    func requestNextStep(
        category: GameCategory,
        history: [GameTurn]
    ) async throws -> AIGameDecision
    
    func requestQuizChoices(
        category: GameCategory,
        correctWord: String
    ) async throws -> [QuizChoice]
    
    func verifyHonesty(
        category: GameCategory,
        history: [GameTurn],
        claimedWord: String
    ) async throws -> HonestyVerdict
}
