//
//  AchievementsEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum AchievementsEndpoint: Endpoint {
    case getAchievements(status: String)
    case getWeeklyReward
    case claimWeeklyReward
    
    var path: String {
        switch self {
        case .getAchievements:
            return "/achievements"
        case .getWeeklyReward:
            return "/achievements/weekly-reward"
        case .claimWeeklyReward:
            return "/achievements/weekly-reward/claim"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAchievements, .getWeeklyReward:
            return .get
        case .claimWeeklyReward:
            return .post
        }
    }
    
    var body: EmptyBody? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAchievements(let status):
            return [URLQueryItem(name: "status", value: status)]
        case .getWeeklyReward, .claimWeeklyReward:
            return nil
        }
    }
}
