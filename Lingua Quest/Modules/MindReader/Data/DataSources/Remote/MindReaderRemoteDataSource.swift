

import Foundation

final class MindReaderRemoteDataSource: MindReaderRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchWorlds() async throws -> [MindReaderWorldDTO] {
        let endpoint = MindReaderEndpoint.GetWorlds()
        return try await apiClient.request(endpoint)
    }
    
    func fetchWorldMatrix(worldId: String) async throws -> MindReaderWorldMatrixDTO {
        let endpoint = MindReaderEndpoint.GetWorldMatrix(worldId: worldId)
        return try await apiClient.request(endpoint)
    }
    
    func submitResult(worldId: String, result: TrapValidationResult) async throws {
        let isVictory: Bool
        let coins: Int
        let xp: Int
        let reason: String?
        
        switch result {
        case .victory(let coinsEarned, let xpEarned, _):
            isVictory = true
            coins = coinsEarned
            xp = xpEarned
            reason = nil
        case .busted(let failureReason):
            isVictory = false
            coins = 0
            xp = 0
            reason = failureReason
        }
        
        let endpoint = MindReaderEndpoint.SaveGameResult(
            worldId: worldId,
            isVictory: isVictory,
            coinsEarned: coins,
            xpEarned: xp,
            reason: reason
        )
        
        let _: EmptyBody? = try await apiClient.request(endpoint)
    }
}
