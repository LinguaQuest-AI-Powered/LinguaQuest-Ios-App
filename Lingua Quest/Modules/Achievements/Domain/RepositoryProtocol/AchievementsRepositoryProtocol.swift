//
//  AchievementsRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol AchievementsRepositoryProtocol {
    func getFullAchievements(status: String) async throws -> AchievementsDataEntity
    func getWeeklyReward() async throws -> WeeklyRewardEntity
    func claimWeeklyReward() async throws -> ClaimRewardResultEntity
}
