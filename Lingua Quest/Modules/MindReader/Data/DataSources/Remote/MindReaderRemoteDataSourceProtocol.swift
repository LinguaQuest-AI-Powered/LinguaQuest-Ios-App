//
//  MindReaderRemoteDataSourceProtocol.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

protocol MindReaderRemoteDataSourceProtocol {
    func requestNextStep(
        categoryContext: String,
        historyPrompt: String,
        targetLanguage: String,
        nativeLanguage: String
    ) async throws -> AkinatorStepResponseDTO

    func requestQuizChoices(
        categoryContext: String,
        correctWordTargetLanguage: String,
        correctWordNativeLanguage: String,
        nativeLanguage: String,
        targetLanguage: String
    ) async throws -> [QuizChoiceDTO]

    func verifyHonesty(
        categoryContext: String,
        historyPrompt: String,
        claimedWord: String,
        feedbackLanguage: String
    ) async throws -> HonestyResponseDTO
}
