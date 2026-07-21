//
//  GetHomeWorldsUseCase.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

protocol GetHomeWorldsUseCaseProtocol {
    func execute(languageId: Int, difficulty: String?) async throws -> [ExploreWorld]
}

struct GetHomeWorldsUseCase: GetHomeWorldsUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(languageId: Int, difficulty: String?) async throws -> [ExploreWorld] {
        return try await repository.getWorlds(languageId: languageId, difficulty: difficulty)
    }
}
