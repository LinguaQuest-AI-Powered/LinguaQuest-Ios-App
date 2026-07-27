//
//  ActivateLockScreenVocabularyUseCase.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Foundation

protocol ActivateLockScreenVocabularyUseCaseProtocol {
    func execute() async -> Result<Void, Error>
}

final class ActivateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol {
    private let generateVocabularyWordsUseCase: GenerateVocabularyWordsUseCaseProtocol
    private let getSavedVocabularyWordsUseCase: GetSavedVocabularyWordsUseCaseProtocol
    private let scheduleVocabularyNotificationUseCase: ScheduleVocabularyNotificationUseCaseProtocol
    private var userPreferences: UserPreferencesProtocol
    init(generateVocabularyWordsUseCase: GenerateVocabularyWordsUseCaseProtocol,
         getSavedVocabularyWordsUseCase: GetSavedVocabularyWordsUseCaseProtocol,
         scheduleVocabularyNotificationUseCase: ScheduleVocabularyNotificationUseCaseProtocol,
         userPreferences: UserPreferencesProtocol) {
        self.generateVocabularyWordsUseCase = generateVocabularyWordsUseCase
        self.getSavedVocabularyWordsUseCase = getSavedVocabularyWordsUseCase
        self.scheduleVocabularyNotificationUseCase = scheduleVocabularyNotificationUseCase
        self.userPreferences = userPreferences
    }
    
    func execute() async -> Result<Void, Error> {
        // 2. Persist flag
        userPreferences.isLockScreenVocabularyEnabled = true
        
        let targetLang = userPreferences.targetLanguageName ?? "English"
        do {
            let existingWords = try await getSavedVocabularyWordsUseCase.execute()
            let unshownWords = existingWords.filter { !$0.isShownOnLockScreen }
            
            if unshownWords.isEmpty {
                _ = try await generateVocabularyWordsUseCase.execute(
                    targetLanguage: targetLang,
                    count: AppConstants.Common.noOfWordsForLockScreenVocabulary,
                    excludeWords: nil
                )
            }
            return .success(())
        } catch {
            // For simplicity, if generation fails initially, we still activated it,
            // the user just won't have words until the next generation cycle.
            print("Failed to activate lock screen vocabulary words: \(error)")
            return .success(())
        }
    }
}
