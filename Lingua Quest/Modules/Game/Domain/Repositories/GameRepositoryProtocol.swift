//
//  GameRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

protocol GameRepositoryProtocol {
    func getLevels(worldId: Int, languageId: Int) async throws -> [GameLevel]
    func startLevel(worldId: Int, levelId: Int) async throws -> StartLevelEntity
    func changeWord(worldId: Int, levelId: Int) async throws -> ChangeWordEntity
    func verifyImage(worldId: Int, levelId: Int, imageData: Data) async throws -> VerifyImageEntity
    func getHint(worldId: Int, levelId: Int) async throws -> GetHintEntity
}
