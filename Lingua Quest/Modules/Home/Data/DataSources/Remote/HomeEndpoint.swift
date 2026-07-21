//
//  HomeEndpoint.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

enum HomeEndpoint {
    struct GetHomeData: Endpoint {
        var body: EmptyBody?
        var path: String { "/home" }
        var method: HTTPMethod { .get }
    }
    
    struct GetWorlds: Endpoint {
        var body: EmptyBody?
        
        let languageId: Int
        let difficulty: String
        
        var path: String { "/worlds" }
        var method: HTTPMethod { .get }
        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "languageId", value: "\(languageId)"),
                URLQueryItem(name: "difficulty", value: difficulty)
            ]
        }
    }
    
    struct GetDailyReward: Endpoint {
        var body: EmptyBody?
        var path: String { "/daily-reward" }
        var method: HTTPMethod { .get }
    }
    
    struct ClaimDailyReward: Endpoint {
        var body: EmptyBody?
        var path: String { "/daily-reward/claim" }
        var method: HTTPMethod { .post }
    }
}
