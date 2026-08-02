//
//  RequestQuizChoicesUseCase.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct RequestQuizChoicesUseCase {
    let repository: MindReaderRepositoryProtocol
    
    func execute(category: GameCategory, correctWord: String) async throws -> [QuizChoice] {
        return try await repository.requestQuizChoices(category: category, correctWord: correctWord)
    }
}
