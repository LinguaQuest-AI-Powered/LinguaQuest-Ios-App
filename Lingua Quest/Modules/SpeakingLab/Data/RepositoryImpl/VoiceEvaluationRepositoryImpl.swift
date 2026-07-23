//
//  VoiceEvaluationRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import UIKit

class VoiceEvaluationRepositoryImpl: VoiceEvaluationRepositoryProtocol {
    private let evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol
    private let progressDataSource: VoiceProgressRemoteDataSourceProtocol
    private let generatorDataSource: VoiceSentenceGeneratorDataSourceProtocol
    
    private var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
    }
    
    init(
        evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol,
        progressDataSource: VoiceProgressRemoteDataSourceProtocol,
        generatorDataSource: VoiceSentenceGeneratorDataSourceProtocol
    ) {
        self.evaluationDataSource = evaluationDataSource
        self.progressDataSource = progressDataSource
        self.generatorDataSource = generatorDataSource
    }
    
    func getDailySentences() async throws -> [VoiceSentence] {
        // Check Firestore for today's sentences
        if let cachedDTOs = try await progressDataSource.getTodaySentences(deviceId: deviceId) {
            let sentences: [VoiceSentence] = cachedDTOs.map { $0.toEntity() }
            return sentences
        }
        
        // Generate new sentences via AI
        let language = "German"
        let generatedDTOs = try await generatorDataSource.generateSentences(language: language, count: 5)
        
        // Save to Firestore
        try await progressDataSource.saveDailySentences(deviceId: deviceId, sentences: generatedDTOs)
        
        let sentences: [VoiceSentence] = generatedDTOs.map { $0.toEntity() }
        return sentences
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
    
    func markSentenceCompleted(sentenceId: String) async throws {
        try await progressDataSource.markSentenceCompleted(deviceId: deviceId, sentenceId: sentenceId)
    }
    
    func getProgress() async throws -> (completed: Int, total: Int) {
        return try await progressDataSource.getProgress(deviceId: deviceId)
    }
}
