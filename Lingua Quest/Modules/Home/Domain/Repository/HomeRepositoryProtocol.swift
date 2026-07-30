//
//  HomeRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

protocol HomeRepositoryProtocol {
    func getHomeData() async throws -> HomeData
    func getWorlds(languageId: Int, difficulty: String?) async throws -> [ExploreWorld]
    func getDailyReward() async throws -> DailyRewardEntity
    func claimDailyReward() async throws -> DailyRewardClaimEntity
    
    func getMyLanguages() async throws -> [MyTargetLanguage]
    func getAvailableLanguages() async throws -> [AvailableLanguage]
    func switchActiveLanguage(languageId: Int) async throws -> MyTargetLanguage
    func addLanguages(languageIds: [Int]) async throws -> [MyTargetLanguage]
    func changeNativeLanguage(languageId: Int) async throws
}
