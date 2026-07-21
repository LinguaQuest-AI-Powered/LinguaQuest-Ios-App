//
//  GameRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import Foundation

protocol GameRepositoryProtocol {
    func getLevels(worldId: Int) async throws -> [GameLevel]
}
