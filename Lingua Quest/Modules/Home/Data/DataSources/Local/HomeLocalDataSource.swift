//
//  HomeLocalDataSource.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 22/07/2026.
//

import Foundation

protocol HomeLocalDataSourceProtocol: AnyObject {
    var homeData: HomeData? { get set }
    var dailyReward: DailyRewardEntity? { get set }
    var myLanguages: [MyTargetLanguage]? { get set }
    var availableLanguages: [AvailableLanguage]? { get set }
    
    func getWorlds(languageId: Int, difficulty: String?) -> [ExploreWorld]?
    func saveWorlds(_ worlds: [ExploreWorld], languageId: Int, difficulty: String?)
    
    func clearCache()
}

final class HomeLocalDataSource: HomeLocalDataSourceProtocol {
    var homeData: HomeData?
    var dailyReward: DailyRewardEntity?
    var myLanguages: [MyTargetLanguage]?
    var availableLanguages: [AvailableLanguage]?
    
    private var worldsCache: [String: [ExploreWorld]] = [:]
    
    private func cacheKey(languageId: Int, difficulty: String?) -> String {
        return "\(languageId)_\(difficulty ?? "NONE")"
    }
    
    func getWorlds(languageId: Int, difficulty: String?) -> [ExploreWorld]? {
        return worldsCache[cacheKey(languageId: languageId, difficulty: difficulty)]
    }
    
    func saveWorlds(_ worlds: [ExploreWorld], languageId: Int, difficulty: String?) {
        worldsCache[cacheKey(languageId: languageId, difficulty: difficulty)] = worlds
    }
    
    func clearCache() {
        homeData = nil
        dailyReward = nil
        myLanguages = nil
        availableLanguages = nil
        worldsCache.removeAll()
    }
}
