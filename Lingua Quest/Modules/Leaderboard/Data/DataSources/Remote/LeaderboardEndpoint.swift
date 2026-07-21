//
//  LeaderboardEndpoint.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

enum LeaderboardEndpoint: Endpoint {
    case getLeaderboard(scope: String, languageId: Int, page: Int, limit: Int)
    
    var path: String {
        switch self {
        case .getLeaderboard:
            return "/leaderboard"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLeaderboard:
            return .get
        }
    }
    
    var body: EmptyBody? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getLeaderboard(let scope, let languageId, let page, let limit):
            return [
                URLQueryItem(name: "scope", value: scope),
                URLQueryItem(name: "languageId", value: "\(languageId)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
    }
}
