//
//  GetAchievementsUseCase.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol GetAchievementsUseCaseProtocol {
    func execute(status: String) async throws -> AchievementsDataEntity
}

final class GetAchievementsUseCase: GetAchievementsUseCaseProtocol {
    private let repository: AchievementsRepositoryProtocol

    init(repository: AchievementsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(status: String) async throws -> AchievementsDataEntity {
        return try await repository.getFullAchievements(status: status)
    }
}
