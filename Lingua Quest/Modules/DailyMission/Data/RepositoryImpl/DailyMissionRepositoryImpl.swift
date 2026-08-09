//
//  DailyMissionRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

struct DailyMissionRepositoryImpl: DailyMissionRepositoryProtocol {
    private let remoteDataSource: DailyMissionRemoteDataSourceProtocol

    init(remoteDataSource: DailyMissionRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getMission() async throws -> DailyMissionWordEntity {
        let response = try await remoteDataSource.getMission()
        guard let data = response.data else {
            throw NetworkError.serverError(statusCode: 404, data: nil)
        }
        return DailyMissionWordEntity(
            word: data.word,
            isSolved: data.isSolved ?? false
        )
    }

    func verifyMission(imageData: Data, word: String) async throws -> DailyMissionResultEntity {
        let response = try await remoteDataSource.verifyMission(imageData: imageData, word: word)
        guard let data = response.data else {
            throw NetworkError.serverError(statusCode: 500, data: nil)
        }
        return DailyMissionResultEntity(
            isMatch: data.isMatch,
            xpEarned: data.xpEarned ?? 0,
            coinsEarned: data.coinsEarned ?? 0
        )
    }
}
