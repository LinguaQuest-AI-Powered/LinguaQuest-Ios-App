//
//  LockScreenVocabularyManager.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import SwiftUI
import ActivityKit

@Observable
class LockScreenVocabularyManager {
    private var preloadedWord: VocabularyWordEntity?
    
    init() {}
    
    func handleScenePhaseChange(to newPhase: ScenePhase) {
        if newPhase == .inactive {
            scheduleVocabularyIfNeeded()
        } else if newPhase == .active {
            endVocabularyLiveActivity()
            preloadVocabularyIfNeeded()
        }
    }
    
    private func endVocabularyLiveActivity() {
        if #available(iOS 16.2, *) {
            Task {
                for activity in Activity<WordWidgetAttributes>.activities {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
        }
    }
    
    private func preloadVocabularyIfNeeded() {
        let isEnabled = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
        print("LiveActivity Debug: preloadVocabularyIfNeeded called. isEnabled = \(isEnabled)")
        guard isEnabled else { return }
        
        let getSavedWords = Resolver.shared.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)
        Task {
            do {
                var allWords = try await getSavedWords.execute()
                print("LiveActivity Debug: Fetched \(allWords.count) total words from DB")
                
                let userPrefs = Resolver.shared.resolve(UserPreferencesProtocol.self)
                let targetCode = userPrefs.learningLanguageCode ?? "en"
                let englishLocale = Locale(identifier: "en_US")
                let targetLang = englishLocale.localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
                
                allWords = allWords.filter { $0.targetLanguage == targetLang }
                let unshownWords = allWords.filter { !$0.isShownOnLockScreen }.sorted { $0.createdAt < $1.createdAt }
                print("LiveActivity Debug: TargetLang = \(targetLang), unshownWords count = \(unshownWords.count)")
                
                self.preloadedWord = unshownWords.first
                print("LiveActivity Debug: preloadedWord set to \(self.preloadedWord?.word ?? "nil")")
                
                // Replenish if empty
                if unshownWords.isEmpty {
                    print("LiveActivity Debug: unshownWords is empty, triggering AI generation in background...")
                    let excludeList = allWords.map { $0.word }
                    let generateWords = Resolver.shared.resolve(GenerateVocabularyWordsUseCaseProtocol.self)
                    
                    var preloadBgTask: UIBackgroundTaskIdentifier = .invalid
                    preloadBgTask = UIApplication.shared.beginBackgroundTask {
                        UIApplication.shared.endBackgroundTask(preloadBgTask)
                        preloadBgTask = .invalid
                    }
                    
                    Task {
                        defer {
                            UIApplication.shared.endBackgroundTask(preloadBgTask)
                            preloadBgTask = .invalid
                        }
                        
                        do {
                            _ = try await generateWords.execute(
                                targetLanguage: targetLang, 
                                count: AppConstants.Common.noOfWordsForLockScreenVocabulary, 
                                excludeWords: excludeList
                            )
                            print("LiveActivity Debug: AI generation finished from preload.")
                            
                            // If we didn't have a word, let's try to fetch again after generation
                            if self.preloadedWord == nil {
                                let updatedWords = try await getSavedWords.execute()
                                print("LiveActivity Debug: After generation, DB has \(updatedWords.count) total words.")
                                
                                let newWords = updatedWords.filter({ $0.targetLanguage == targetLang && !$0.isShownOnLockScreen }).sorted(by: { $0.createdAt < $1.createdAt })
                                print("LiveActivity Debug: After generation, found \(newWords.count) new unshown words for \(targetLang).")
                                
                                self.preloadedWord = newWords.first
                                print("LiveActivity Debug: preloadedWord dynamically updated after generation to \(self.preloadedWord?.word ?? "nil")")
                            }
                        } catch {
                            print("LiveActivity Debug: ERROR generating words: \(error)")
                        }
                    }
                }
            } catch {
                print("LiveActivity Debug: Failed to preload vocabulary: \(error)")
            }
        }
    }
    
    private func scheduleVocabularyIfNeeded() {
        let isEnabled = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
        print("LiveActivity Debug: scheduleVocabularyIfNeeded called (on .inactive). isEnabled = \(isEnabled), preloadedWord = \(preloadedWord?.word ?? "nil")")
        guard isEnabled, let wordToDisplay = preloadedWord else {
            print("LiveActivity Debug: Aborting launch because isEnabled is false or preloadedWord is nil")
            return 
        }
        
        print("LiveActivity Debug: Launching Activity for word: \(wordToDisplay.word)")
        // 1. Launch Live Activity synchronously before app enters background
        if #available(iOS 16.2, *) {
            let userPrefs = Resolver.shared.resolve(UserPreferencesProtocol.self)
            let targetCode = userPrefs.learningLanguageCode ?? "en"
            let currentLanguageCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
            let targetLang = Locale(identifier: "en_US").localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
            let localizedTargetLang = Locale(identifier: currentLanguageCode).localizedString(forLanguageCode: targetCode)?.capitalized ?? targetLang
            
            let localizedDifficulty: String
            switch wordToDisplay.difficulty.lowercased() {
            case "easy": localizedDifficulty = L10n.Home.difficultyEasy
            case "medium": localizedDifficulty = L10n.Home.difficultyMedium
            case "hard": localizedDifficulty = L10n.Home.difficultyHard
            default: localizedDifficulty = wordToDisplay.difficulty
            }
            
            let isDarkMode = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode)
            let isAppArabic = currentLanguageCode.contains("ar")
            
            let attributes = WordWidgetAttributes()
            let state = WordWidgetAttributes.ContentState(
                wordId: wordToDisplay.id.uuidString,
                word: wordToDisplay.word,
                meaning: wordToDisplay.meaning,
                difficulty: wordToDisplay.difficulty,
                targetLanguage: wordToDisplay.targetLanguage,
                localizedAppName: L10n.Components.appName,
                localizedTapToOpen: L10n.LockScreenVocabulary.tapToOpenAndListen,
                localizedDifficulty: localizedDifficulty,
                localizedTargetLanguage: localizedTargetLang,
                isDarkMode: isDarkMode,
                isAppArabic: isAppArabic
            )
            do {
                _ = try Activity.request(attributes: attributes, contentState: state, pushType: nil)
            } catch {
                print("Failed to request Live Activity: \(error)")
            }
        }
        
        // 2. Perform DB update and AI Generation in background task
        var bgTask: UIBackgroundTaskIdentifier = .invalid
        bgTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }
        
        let markWordAsShown = Resolver.shared.resolve(MarkVocabularyWordAsShownUseCaseProtocol.self)
        let pickedWordId = wordToDisplay.id
        
        Task {
            defer {
                UIApplication.shared.endBackgroundTask(bgTask)
                bgTask = .invalid
            }
            do {
                try await markWordAsShown.execute(id: pickedWordId)
                print("LiveActivity Debug: Marked word as shown in background task")
            } catch {
                print("LiveActivity Debug: Failed background DB operations for Live Activity: \(error)")
            }
        }
    }
}
