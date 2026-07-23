//
//  ClaimDailyRewardUseCase.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct ClaimDailyRewardUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> DailyRewardClaimEntity {
        return try await repository.claimDailyReward()
    }
}
