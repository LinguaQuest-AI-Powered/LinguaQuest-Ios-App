//
//  LeaderboardRepositoryImpl.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

final class LeaderboardRepositoryImpl: LeaderboardRepositoryProtocol {
    private let remoteDataSource: LeaderboardRemoteDataSourceProtocol

    init(remoteDataSource: LeaderboardRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getLeaderboard(scope: String, languageId: Int, page: Int, limit: Int) async throws -> LeaderboardDataEntity {
        let response = try await remoteDataSource.fetchLeaderboard(scope: scope, languageId: languageId, page: page, limit: limit)
        let data = response.data
        
        let mapUser: (LeaderboardUserDTO) -> LeaderboardUserEntity = { dto in
            LeaderboardUserEntity(
                id: "\(dto.userId)",
                rank: dto.rank,
                name: dto.username,
                title: "Level \(dto.level)", // Provide a fallback title or map it appropriately
                avatarImage: dto.photoUrl,
                xp: dto.xp,
                isCurrentUser: dto.isCurrentUser
            )
        }
        
        let topThree = data.topThree.map(mapUser)
        let entries = data.entries.map(mapUser)
        
        return LeaderboardDataEntity(
            myRank: data.myRank,
            topThree: topThree,
            entries: entries
        )
    }
}
