//
//  Lingua_QuestApp.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import SwiftData
import GoogleSignIn
import ActivityKit

@main
struct MyApp: App {
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        _ = Resolver.shared
    }

    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    if url.scheme == "linguaquest" && url.host == "word" {
                        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let idStr = components.queryItems?.first(where: { $0.name == "id" })?.value,
                           let id = UUID(uuidString: idStr) {
                            NotificationCenter.default.post(
                                name: NSNotification.Name("VocabularyNotificationTapped"),
                                object: nil,
                                userInfo: ["wordId": id]
                            )
                        }
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                }
        }
        .modelContainer(for: [CapturedItemEntity.self, VocabularyWordSwiftDataEntity.self])
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .inactive {
                scheduleVocabularyIfNeeded()
            } else if newPhase == .active {
                endVocabularyLiveActivity()
            }
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
    
    private func scheduleVocabularyIfNeeded() {
        let isEnabled = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
        guard isEnabled else { return }
        
        let getSavedWords = Resolver.shared.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)
        let generateWords = Resolver.shared.resolve(GenerateVocabularyWordsUseCaseProtocol.self)
        let markWordAsShown = Resolver.shared.resolve(MarkVocabularyWordAsShownUseCaseProtocol.self)
        
        Task {
            do {
                var allWords = try await getSavedWords.execute()
                
                let targetCode = AppConstants.Common.targetLanguageValue
                let englishLocale = Locale(identifier: "en_US")
                let targetLang = englishLocale.localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
                
                // Filter words by the current target language
                allWords = allWords.filter { $0.targetLanguage == targetLang }
                
                let unshownWords = allWords.filter { !$0.isShownOnLockScreen }.sorted { $0.createdAt < $1.createdAt }
                
                var pickedWord: VocabularyWordEntity?
                
                if let nextWord = unshownWords.first {
                    pickedWord = nextWord
                    try await markWordAsShown.execute(id: nextWord.id)
                }
                
                // Replenish if less than 5 unshown words remain
                if unshownWords.count <= 5 {
                    let excludeList = allWords.map { $0.word }
                    // Generate and save, this will run in the background
                    _ = try? await generateWords.execute(targetLanguage: targetLang, count: 20, excludeWords: excludeList)
                }
                
                guard let wordToDisplay = pickedWord else { return }
                
                if #available(iOS 16.2, *) {
                        let attributes = WordWidgetAttributes()
                        let currentLanguageCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
                        let localizedTargetLang = Locale(identifier: currentLanguageCode).localizedString(forLanguageCode: targetCode)?.capitalized ?? wordToDisplay.targetLanguage
                        
                        let localizedDifficulty: String
                        switch wordToDisplay.difficulty.lowercased() {
                        case "easy": localizedDifficulty = L10n.Home.difficultyEasy
                        case "medium": localizedDifficulty = L10n.Home.difficultyMedium
                        case "hard": localizedDifficulty = L10n.Home.difficultyHard
                        default: localizedDifficulty = wordToDisplay.difficulty
                        }
                        
                        let isDarkMode = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode)
                        let isAppArabic = currentLanguageCode.contains("ar")
                        
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
            } catch {
                print("Failed to schedule vocabulary on background: \(error)")
            }
        }
    }
}
