//
//  DailyMissionUseCases.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

struct GetDailyMissionUseCase {
    let repository: DailyMissionRepositoryProtocol

    func execute() async throws -> DailyMissionWordEntity {
        try await repository.getMission()
    }
}

struct VerifyDailyMissionUseCase {
    let repository: DailyMissionRepositoryProtocol

    func execute(imageData: Data, word: String) async throws -> DailyMissionResultEntity {
        try await repository.verifyMission(imageData: imageData, word: word)
    }
}
