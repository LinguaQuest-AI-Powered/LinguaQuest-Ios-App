//
//  AIEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

/// A reusable base protocol for AI Endpoints that routes to `AppConfig.aiBaseURL`
/// and automatically sets the `Authorization` header to the `aiKey`.
protocol AIEndpoint: Endpoint {}

extension AIEndpoint {
    var baseURL: URL { AppConfig.aiBaseURL }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AppConfig.aiKey)"
        ]
    }
    
    // We set requiresAuth to false so the main APIClient doesn't overwrite 
    // our AI Bearer token with the user's App Auth token.
    var requiresAuth: Bool { false }
}
