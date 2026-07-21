//
//  VoiceEvaluationRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

protocol VoiceEvaluationRepositoryProtocol {
    func getDailySentences() async throws -> [VoiceSentence]
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResult
    func saveSentenceProgress(sentenceId: String, result: VoiceEvaluationResult) async throws
}
