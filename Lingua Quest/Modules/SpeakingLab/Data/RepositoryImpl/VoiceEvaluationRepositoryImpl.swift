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
    private let userPreferences: UserPreferencesProtocol
    
    private var userId: String {
        if let id = userPreferences.userId {
            return String(id)
        }
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
    }
    
    init(
        evaluationDataSource: VoiceEvaluationRemoteDataSourceProtocol,
        progressDataSource: VoiceProgressRemoteDataSourceProtocol,
        generatorDataSource: VoiceSentenceGeneratorDataSourceProtocol,
        speechRecognitionService: SpeechRecognitionServiceProtocol,
        userPreferences: UserPreferencesProtocol
    ) {
        self.evaluationDataSource = evaluationDataSource
        self.progressDataSource = progressDataSource
        self.generatorDataSource = generatorDataSource
        self.speechRecognitionService = speechRecognitionService
        self.userPreferences = userPreferences
    }
    
    func getDailySentences(languageName: String, languageCode: String) async throws -> [VoiceSentence] {
        // Check Firestore for today's sentences
        if let cachedDTOs = try await progressDataSource.getTodaySentences(userId: userId, languageCode: languageCode) {
            let sentences: [VoiceSentence] = cachedDTOs.map { $0.toEntity() }
            return sentences
        }
        
        // Generate new sentences via AI
        let generatedDTOs = try await generatorDataSource.generateSentences(language: languageName, count: 5)
        
        // Save to Firestore
        try await progressDataSource.saveDailySentences(userId: userId, languageCode: languageCode, sentences: generatedDTOs)
        
        let sentences: [VoiceSentence] = generatedDTOs.map { $0.toEntity() }
        return sentences
    }
    
    func evaluateAudio(audioData: Data, targetText: String, languageCode: String) async throws -> VoiceEvaluationResult {
        // Step 1: Save audio to a temp file for SFSpeechRecognizer
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("eval_recording.m4a")
        try audioData.write(to: tempURL)
        
        // Step 2: Transcribe audio locally using Apple Speech Recognition
        // Use the proper locale since that's the target language
        let speechCode = SpeechLocaleMapper.mapToSpeechCode(languageCode)
        let locale = Locale(identifier: speechCode)
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
    
    func markSentenceCompleted(sentenceId: String, languageCode: String) async throws {
        try await progressDataSource.markSentenceCompleted(userId: userId, languageCode: languageCode, sentenceId: sentenceId)
    }
    
    func getProgress(languageCode: String) async throws -> (completed: Int, total: Int) {
        return try await progressDataSource.getProgress(userId: userId, languageCode: languageCode)
    }
}
