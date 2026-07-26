//
//  BossLevelRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

enum BossLevelEvent {
    case stateChanged(BossLevelSessionState)
    case messageReceived(RoleplayMessage)
    case aiTranscriptChunk(String)
    case turnCompleted
    case error(Error)
}

protocol BossLevelRepositoryProtocol: AnyObject {
    var stateStream: AsyncStream<BossLevelEvent> { get }

    func startSession(systemInstruction: String) async throws
    func stopSession() async
    func startSpeaking()
    func stopSpeaking()
    func evaluateStage(scenario: BossScenario, transcript: String) async throws -> BossEvaluationResult
}
