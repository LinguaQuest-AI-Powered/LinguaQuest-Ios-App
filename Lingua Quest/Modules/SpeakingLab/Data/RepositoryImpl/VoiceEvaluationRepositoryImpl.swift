//
//  VoiceEvaluationRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

class VoiceEvaluationRepositoryImpl: VoiceEvaluationRepositoryProtocol {
    private let evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol
    private let progressDataSource: VoiceProgressRemoteDataSourceProtocol
    private let userId: String // In a real app, this would come from a SessionManager or Auth service
    
    init(evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol, progressDataSource: VoiceProgressRemoteDataSourceProtocol) {
        self.evaluationDataSource = evaluationDataSource
        self.progressDataSource = progressDataSource
        self.userId = "current_user_123" // Mock user ID for now
    }
    
    func getDailySentences() async throws -> [VoiceSentence] {
        return try await progressDataSource.getDailySentences()
    }
    
    func evaluateAudio(audioData: Data, targetText: String) async throws -> VoiceEvaluationResult {
        let dto = try await evaluationDataSource.evaluateAudio(audioData: audioData, targetText: targetText)
        
        return VoiceEvaluationResult(
            rating: dto.rating,
            correctWords: dto.correct_words,
            wrongWords: dto.wrong_words,
            advice: dto.advice
        )
    }
    
    func saveSentenceProgress(sentenceId: String, result: VoiceEvaluationResult) async throws {
        let dto = VoiceEvaluationResponseDTO(
            rating: result.rating,
            correct_words: result.correctWords,
            wrong_words: result.wrongWords,
            advice: result.advice
        )
        
        try await progressDataSource.saveSentenceProgress(userId: userId, sentenceId: sentenceId, result: dto)
    }
}
