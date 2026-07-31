

import Foundation

enum MindReaderEndpoint {
    struct GetWorlds: Endpoint {
        var body: EmptyBody?
        var path: String { "/mind-reader/worlds" }
        var method: HTTPMethod { .get }
    }
    
    struct GetWorldMatrix: Endpoint {
        var body: EmptyBody?
        let worldId: String
        
        var path: String { "/mind-reader/worlds/\(worldId)/matrix" }
        var method: HTTPMethod { .get }
    }
    
    struct SaveGameResult: Endpoint {
        struct SaveResultBody: Encodable {
            let worldId: String
            let isVictory: Bool
            let coinsEarned: Int
            let xpEarned: Int
            let reason: String?
        }
        
        var body: SaveResultBody?
        var path: String { "/mind-reader/results" }
        var method: HTTPMethod { .post }
        
        init(worldId: String, isVictory: Bool, coinsEarned: Int, xpEarned: Int, reason: String? = nil) {
            self.body = SaveResultBody(
                worldId: worldId,
                isVictory: isVictory,
                coinsEarned: coinsEarned,
                xpEarned: xpEarned,
                reason: reason
            )
        }
    }
}
