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
    /// Tracks the word ID currently displayed on the Lock Screen to prevent duplicate launches.
    private var currentlyDisplayedWordId: UUID?

    /// Debounce handle so a rapid inactive→active→inactive "flicker" (common on iOS during
    /// lock/unlock, Face ID overlays, etc.) doesn't trigger two separate schedule/replenish runs.
    private var pendingPhaseTask: Task<Void, Never>?

    /// Small delay to let the scenePhase settle before acting on it.
    private let phaseDebounceNanoseconds: UInt64 = 400_000_000 // 0.4s

    init() {}

    func handleScenePhaseChange(to newPhase: ScenePhase) {
        // Cancel any previously scheduled (not-yet-executed) work — if the phase
        // is still bouncing, only the LAST stable phase should actually run.
        pendingPhaseTask?.cancel()

        pendingPhaseTask = Task {
            do {
                try await Task.sleep(nanoseconds: phaseDebounceNanoseconds)
            } catch {
                return // cancelled by a newer phase change, do nothing
            }
            guard !Task.isCancelled else { return }

            if newPhase == .inactive {
                await scheduleVocabularyIfNeeded()
            } else if newPhase == .active {
                endVocabularyLiveActivity()
                await replenishWordsIfNeeded()
            }
        }
    }

    // MARK: - On Active: End Activities & Replenish

    private func endVocabularyLiveActivity() {
        currentlyDisplayedWordId = nil
        if #available(iOS 16.2, *) {
            Task {
                for activity in Activity<WordWidgetAttributes>.activities {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
        }
    }

    /// Checks if all words for the current language have been shown.
    /// If so, generates a new batch of words from AI.
    private func replenishWordsIfNeeded() async {
        let userPrefs = Resolver.shared.resolve(UserPreferencesProtocol.self)
        guard userPrefs.isLockScreenVocabularyEnabled else { return }

        let getSavedWords = Resolver.shared.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)

        do {
            let allWords = try await getSavedWords.execute()
            let unshownWords = allWords.filter { !$0.isShownOnLockScreen }

            print("LiveActivity Debug: replenish check — total: \(allWords.count), unshown: \(unshownWords.count)")

            guard unshownWords.isEmpty else { return }

            print("LiveActivity Debug: All words shown, generating new batch...")

            let targetCode = userPrefs.learningLanguageCode ?? "en"
            let targetLang = Locale(identifier: "en_US").localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
            let excludeList = allWords.map { $0.word }
            let generateWords = Resolver.shared.resolve(GenerateVocabularyWordsUseCaseProtocol.self)

            var bgTask: UIBackgroundTaskIdentifier = .invalid
            bgTask = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(bgTask)
                bgTask = .invalid
            }

            defer {
                UIApplication.shared.endBackgroundTask(bgTask)
                bgTask = .invalid
            }

            _ = try await generateWords.execute(
                targetLanguage: targetLang,
                count: AppConstants.Common.noOfWordsForLockScreenVocabulary,
                excludeWords: excludeList
            )
            print("LiveActivity Debug: New batch generated successfully.")
        } catch {
            print("LiveActivity Debug: Failed to replenish words: \(error)")
        }
    }

    // MARK: - On Inactive: Pick Word → Show → Mark

    /// Atomic flow: fetch next unshown word → launch Live Activity → mark as shown + journal.
    private func scheduleVocabularyIfNeeded() async {
        let userPrefs = Resolver.shared.resolve(UserPreferencesProtocol.self)
        guard userPrefs.isLockScreenVocabularyEnabled else {
            print("LiveActivity Debug: Lock screen vocabulary not enabled, skipping.")
            return
        }

        // Prevent duplicate launches for the same transition.
        // Also cross-check against the system's own activity list, which is the real
        // source of truth and can't be reset by a spurious phase flicker.
        let hasSystemActivity: Bool
        if #available(iOS 16.2, *) {
            hasSystemActivity = !Activity<WordWidgetAttributes>.activities.isEmpty
        } else {
            hasSystemActivity = false
        }

        guard currentlyDisplayedWordId == nil, !hasSystemActivity else {
            print("LiveActivity Debug: Word already displayed this session, skipping.")
            return
        }

        let getSavedWords = Resolver.shared.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)
        let markWordAsShown = Resolver.shared.resolve(MarkVocabularyWordAsShownUseCaseProtocol.self)
        let markWordAsAddedToJournal = Resolver.shared.resolve(MarkWordAsAddedToJournalUseCaseProtocol.self)

        // Begin a background task to ensure DB operations complete
        var bgTask: UIBackgroundTaskIdentifier = .invalid
        bgTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }

        defer {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }

        do {
            // 1. Fetch the next unshown word
            let allWords = try await getSavedWords.execute()
            let unshownWords = allWords
                .filter { !$0.isShownOnLockScreen }
                .sorted { $0.createdAt < $1.createdAt }

            guard let wordToDisplay = unshownWords.first else {
                print("LiveActivity Debug: No unshown words available, skipping launch.")
                return
            }

            // Re-check cancellation/guard after the await above — another debounced
            // task could theoretically have run in between.
            guard currentlyDisplayedWordId == nil else {
                print("LiveActivity Debug: Word already displayed (post-fetch check), skipping.")
                return
            }

            print("LiveActivity Debug: Picked word: \(wordToDisplay.word)")

            // 2. Track this word BEFORE any awaits that follow, to close the race window.
            currentlyDisplayedWordId = wordToDisplay.id

            // 3. Mark as shown + journal
            try await markWordAsShown.execute(id: wordToDisplay.id)
            try await markWordAsAddedToJournal.execute(id: wordToDisplay.id)
            print("LiveActivity Debug: Marked '\(wordToDisplay.word)' as shown and added to journal.")

            // 4. Launch the Live Activity
            if #available(iOS 16.2, *) {
                launchLiveActivity(for: wordToDisplay, userPrefs: userPrefs)
            }
        } catch {
            print("LiveActivity Debug: Failed to schedule vocabulary: \(error)")
        }
    }

    // MARK: - Live Activity Launch

    @available(iOS 16.2, *)
    private func launchLiveActivity(for word: VocabularyWordEntity, userPrefs: UserPreferencesProtocol) {
        let targetCode = userPrefs.learningLanguageCode ?? "en"
        let currentLanguageCode = userPrefs.appLanguage
        let targetLang = Locale(identifier: "en_US").localizedString(forLanguageCode: targetCode)?.capitalized ?? targetCode
        let localizedTargetLang = Locale(identifier: currentLanguageCode).localizedString(forLanguageCode: targetCode)?.capitalized ?? targetLang

        let localizedDifficulty: String
        switch word.difficulty.lowercased() {
        case "easy": localizedDifficulty = L10n.Home.difficultyEasy
        case "medium": localizedDifficulty = L10n.Home.difficultyMedium
        case "hard": localizedDifficulty = L10n.Home.difficultyHard
        default: localizedDifficulty = word.difficulty
        }

        let isDarkMode = userPrefs.isDarkMode
        let isAppArabic = currentLanguageCode.contains("ar")

        let attributes = WordWidgetAttributes()
        let state = WordWidgetAttributes.ContentState(
            wordId: word.id.uuidString,
            word: word.word,
            meaning: word.meaning,
            difficulty: word.difficulty,
            targetLanguage: word.targetLanguage,
            localizedAppName: L10n.Components.appName,
            localizedTapToOpen: L10n.LockScreenVocabulary.tapToOpenAndListen,
            localizedDifficulty: localizedDifficulty,
            localizedTargetLanguage: localizedTargetLang,
            isDarkMode: isDarkMode,
            isAppArabic: isAppArabic
        )

        do {
            _ = try Activity.request(attributes: attributes, contentState: state, pushType: nil)
            print("LiveActivity Debug: Live Activity launched for '\(word.word)'")
        } catch {
            print("LiveActivity Debug: Failed to request Live Activity: \(error)")
        }
    }
}