//
//  GetLeaderboardUseCase.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol GetLeaderboardUseCaseProtocol {
    func execute(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity
}

final class GetLeaderboardUseCase: GetLeaderboardUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity {
        return try await repository.getLeaderboard(scope: scope, languageId: languageId, page: page, limit: limit)
    }
}
