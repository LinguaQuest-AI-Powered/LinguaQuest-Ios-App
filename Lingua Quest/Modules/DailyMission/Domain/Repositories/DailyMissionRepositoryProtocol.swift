//
//  DailyMissionRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation

protocol DailyMissionRepositoryProtocol {
    func getMission() async throws -> DailyMissionWordEntity
    func verifyMission(imageData: Data, word: String) async throws -> DailyMissionResultEntity
}
