//
//  MindReaderRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

class MindReaderRepositoryImpl: MindReaderRepositoryProtocol {
    private let localDataSource: MindReaderCategoriesLocalDataSourceProtocol
    private let remoteDataSource: MindReaderRemoteDataSourceProtocol

    init(localDataSource: MindReaderCategoriesLocalDataSourceProtocol, remoteDataSource: MindReaderRemoteDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func fetchCategories() -> [GameCategory] {
        return localDataSource.fetchCategories().map { $0.toDomain() }
    }

    func requestNextStep(category: GameCategory, history: [GameTurn]) async throws -> AIGameDecision {
        let historyPrompt = history.map { turn in
            "\(turn.index). Q: \(turn.questionTargetText) -> A: \(turn.answer.rawValue)"
        }.joined(separator: "\n")
        
        let appLangCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        let nativeLanguage = appLangCode == "ar" ? "Arabic" : "English"
        let targetLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.targetLanguageName) ?? "Spanish"

        let dto = try await remoteDataSource.requestNextStep(
            categoryContext: category.promptContext,
            historyPrompt: historyPrompt,
            targetLanguage: targetLanguage,
            nativeLanguage: nativeLanguage
        )
        return try dto.toDomain()
    }
    
    func requestQuizChoices(category: GameCategory, correctWordTargetLanguage: String, correctWordNativeLanguage: String) async throws -> [QuizChoice] {
        let appLangCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        let nativeLanguage = appLangCode == "ar" ? "Arabic" : "English"
        let targetLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.targetLanguageName) ?? "Spanish"
        
        let dtos = try await remoteDataSource.requestQuizChoices(
            categoryContext: category.promptContext,
            correctWordTargetLanguage: correctWordTargetLanguage,
            correctWordNativeLanguage: correctWordNativeLanguage,
            nativeLanguage: nativeLanguage,
            targetLanguage: targetLanguage
        )
        return dtos.map { $0.toDomain() }
    }
    
    func verifyHonesty(category: GameCategory, history: [GameTurn], claimedWord: String) async throws -> HonestyVerdict {
        let historyPrompt = history.map { turn in
            "\(turn.index). Q: \(turn.questionTargetText) -> A: \(turn.answer.rawValue)"
        }.joined(separator: "\n")
        
        let appLangCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        let feedbackLanguage = appLangCode == "ar" ? "Arabic" : "English"
        
        let dto = try await remoteDataSource.verifyHonesty(
            categoryContext: category.promptContext,
            historyPrompt: historyPrompt,
            claimedWord: claimedWord,
            feedbackLanguage: feedbackLanguage
        )
        return dto.toDomain()
    }
}
