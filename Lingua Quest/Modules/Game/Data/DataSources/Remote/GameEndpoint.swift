//
//  GameEndpoint.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

enum GameEndpoint {
    struct Levels: Endpoint {
        var body: EmptyBody?
        
        let worldId: Int

        var path: String { "/worlds/\(worldId)/levels" }
        var method: HTTPMethod { .get }
    }
}
