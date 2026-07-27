//
//  VoiceEvaluationRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

protocol VoiceEvaluationRepositoryProtocol {
    func getDailySentences(languageName: String, languageCode: String) async throws -> [VoiceSentence]
    func evaluateAudio(audioData: Data, targetText: String, languageCode: String) async throws -> VoiceEvaluationResult
    func markSentenceCompleted(sentenceId: String, languageCode: String) async throws
    func getProgress(languageCode: String) async throws -> (completed: Int, total: Int)
}
