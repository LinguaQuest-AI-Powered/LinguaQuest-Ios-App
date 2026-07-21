//
//  HomeRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

protocol HomeRepositoryProtocol {
    func getHomeData() async throws -> HomeData
    func getWorlds(languageId: Int, difficulty: String) async throws -> [ExploreWorld]
    func getDailyReward() async throws -> DailyRewardEntity
    func claimDailyReward() async throws -> DailyRewardClaimEntity
}
