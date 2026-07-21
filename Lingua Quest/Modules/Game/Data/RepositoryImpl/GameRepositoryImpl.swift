//
//  GameRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

struct GameRepositoryImpl: GameRepositoryProtocol {
    private let remoteDataSource: GameRemoteDataSourceProtocol
    
    init(remoteDataSource: GameRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getLevels(worldId: Int) async throws -> [GameLevel] {
        let response = try await remoteDataSource.getLevels(worldId: worldId)
        return response.data.levels.map { dto in
            let status: LevelStatus
            switch dto.status {
            case "COMPLETED":
                status = .completed(stars: 3)
            case "AVAILABLE":
                status = .unlocked
            default:
                status = .locked
            }
            return GameLevel(id: dto.id, order: dto.order, status: status, word: dto.word)
        }
    }
}
