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
    private let scheduleVocabularyNotificationUseCase: ScheduleVocabularyNotificationUseCaseProtocol
    private var userPreferences: UserPreferencesProtocol
    init(generateVocabularyWordsUseCase: GenerateVocabularyWordsUseCaseProtocol,
         scheduleVocabularyNotificationUseCase: ScheduleVocabularyNotificationUseCaseProtocol,
         userPreferences: UserPreferencesProtocol) {
        self.generateVocabularyWordsUseCase = generateVocabularyWordsUseCase
        self.scheduleVocabularyNotificationUseCase = scheduleVocabularyNotificationUseCase
        self.userPreferences = userPreferences
    }
    
    func execute() async -> Result<Void, Error> {
        // 2. Persist flag
        userPreferences.isLockScreenVocabularyEnabled = true
        
  
        let targetCode = AppConstants.Common.targetLanguageValue
        let englishLocale = Locale(identifier: "en_US")
        let targetLang = englishLocale.localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
        
        do {
            _ = try await generateVocabularyWordsUseCase.execute(
                targetLanguage: targetLang,
                count: 20,
                excludeWords: nil
            )
            return .success(())
        } catch {
            // For simplicity, if generation fails initially, we still activated it,
            // the user just won't have words until the next generation cycle.
            print("Failed to generate initial vocabulary words: \(error)")
            return .success(())
        }
    }
}
