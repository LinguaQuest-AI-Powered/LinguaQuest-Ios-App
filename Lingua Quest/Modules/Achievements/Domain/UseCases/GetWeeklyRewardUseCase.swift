//
//  GetWeeklyRewardUseCase.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol GetWeeklyRewardUseCaseProtocol {
    func execute() async throws -> WeeklyRewardEntity
}

final class GetWeeklyRewardUseCase: GetWeeklyRewardUseCaseProtocol {
    private let repository: AchievementsRepositoryProtocol

    init(repository: AchievementsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> WeeklyRewardEntity {
        return try await repository.getWeeklyReward()
    }
}
