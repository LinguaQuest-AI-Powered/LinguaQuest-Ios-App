//
//  ClaimWeeklyRewardUseCase.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol ClaimWeeklyRewardUseCaseProtocol {
    func execute() async throws -> ClaimRewardResultEntity
}

final class ClaimWeeklyRewardUseCase: ClaimWeeklyRewardUseCaseProtocol {
    private let repository: AchievementsRepositoryProtocol

    init(repository: AchievementsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> ClaimRewardResultEntity {
        return try await repository.claimWeeklyReward()
    }
}
