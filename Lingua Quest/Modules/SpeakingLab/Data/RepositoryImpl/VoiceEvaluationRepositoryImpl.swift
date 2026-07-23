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
    private let speechRecognitionService: SpeechRecognitionServiceProtocol
    
    private var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
    }
    
    init(
        evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol,
        progressDataSource: VoiceProgressRemoteDataSourceProtocol,
        generatorDataSource: VoiceSentenceGeneratorDataSourceProtocol,
        speechRecognitionService: SpeechRecognitionServiceProtocol
    ) {
        self.evaluationDataSource = evaluationDataSource
        self.progressDataSource = progressDataSource
        self.generatorDataSource = generatorDataSource
        self.speechRecognitionService = speechRecognitionService
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
        // Step 1: Save audio to a temp file for SFSpeechRecognizer
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("eval_recording.m4a")
        try audioData.write(to: tempURL)
        
        // Step 2: Transcribe audio locally using Apple Speech Recognition
        // Use German locale since that's the target language
        let locale = Locale(identifier: "de-DE")
        let spokenText: String
        do {
            spokenText = try await speechRecognitionService.transcribeAudio(at: tempURL, locale: locale)
            print("Speech Recognition Result: \"\(spokenText)\"")
        } catch {
            print("Speech recognition failed: \(error). Using empty transcription.")
            // If speech recognition fails, send empty text so AI gives 0 score
            let dto = try await evaluationDataSource.evaluateSpokenText(
                spokenText: "",
                targetText: targetText
            )
            return VoiceEvaluationResult(
                rating: dto.rating,
                correctWords: dto.correct_words,
                wrongWords: dto.wrong_words,
                advice: dto.advice
            )
        }
        
        // Step 3: Send transcribed text to AI for evaluation
        let dto = try await evaluationDataSource.evaluateSpokenText(
            spokenText: spokenText,
            targetText: targetText
        )
        
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
