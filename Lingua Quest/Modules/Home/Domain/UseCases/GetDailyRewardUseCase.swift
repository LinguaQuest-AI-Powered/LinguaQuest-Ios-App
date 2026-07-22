//
//  GetDailyRewardUseCase.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct GetDailyRewardUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> DailyRewardEntity {
        return try await repository.getDailyReward()
    }
}
