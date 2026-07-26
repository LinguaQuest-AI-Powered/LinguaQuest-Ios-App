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
    
    func getLevels(worldId: Int, languageId: Int) async throws -> [GameLevel] {
        let response = try await remoteDataSource.getLevels(worldId: worldId, languageId: languageId)
        return response.data.levels.map { dto in
            let status: LevelStatus
            switch dto.status {
            case "COMPLETED":
                status = .completed(stars: 3)
            case "AVAILABLE", "INPROGRESS":
                status = .unlocked
            default:
                status = .locked
            }
            return GameLevel(id: dto.id, order: dto.order, status: status, word: dto.word)
        }
    }
    
    func startLevel(worldId: Int, levelId: Int) async throws -> StartLevelEntity {
        let response = try await remoteDataSource.startLevel(worldId: worldId, levelId: levelId)
        return StartLevelEntity(targetWord: response.data.targetWord)
    }
    
    func changeWord(worldId: Int, levelId: Int) async throws -> ChangeWordEntity {
        let response = try await remoteDataSource.changeWord(worldId: worldId, levelId: levelId)
        return ChangeWordEntity(targetWord: response.data.targetWord, coins: response.data.coins)
    }
    
    func verifyImage(worldId: Int, levelId: Int, imageData: Data) async throws -> VerifyImageEntity {
        let response = try await remoteDataSource.verifyImage(worldId: worldId, levelId: levelId, imageData: imageData)
        return VerifyImageEntity(
            isMatch: response.data.isMatch,
            xpEarned: response.data.xpEarned,
            coinsEarned: response.data.coinsEarned,
            level: response.data.level,
            levelProgressPercentage: response.data.levelProgressPercentage
        )
    }
    
    func getHint(worldId: Int, levelId: Int) async throws -> GetHintEntity {
        let response = try await remoteDataSource.getHint(worldId: worldId, levelId: levelId)
        return GetHintEntity(
            hint: response.data.hint,
            coinsSpent: response.data.coinsSpent,
            remainingCoins: response.data.remainingCoins
        )
    }
}
