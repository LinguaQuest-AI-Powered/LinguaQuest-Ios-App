//
//  LeaderboardRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol LeaderboardRepositoryProtocol {
    func getLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity
}
