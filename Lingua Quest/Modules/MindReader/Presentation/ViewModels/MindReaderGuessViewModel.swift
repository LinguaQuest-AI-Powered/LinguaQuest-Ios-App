//
//  MindReaderGuessViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderGuessViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    private let speechSynthesizer: SpeechSynthesizerProtocol
    
    // MARK: - Computed Properties (from Coordinator)
    
    var guessedWord: String {
        coordinator.bestGuess?.translation ?? ""
    }
    
    var guessedEmoji: String {
        coordinator.bestGuess?.emoji ?? "❓"
    }
    
    var isLoading: Bool = false
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator,
        speechSynthesizer: SpeechSynthesizerProtocol
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
        self.speechSynthesizer = speechSynthesizer
    }
    
    func onListenTapped() {
        guard !guessedWord.isEmpty else { return }
        let targetLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.targetLanguageName) ?? "Spanish"
        speechSynthesizer.speak(text: guessedWord, languageCode: targetLanguage.toSpeechLanguageCode())
    }
    
    func onYesGotItTapped() {
        Task {
            isLoading = true
            await coordinator.requestQuiz()
            isLoading = false
            router.push(.mindReaderTranslation)
        }
    }
    
    func onNoWrongTapped() {
        router.push(.mindReaderGiveUp)
    }
    
    func goBack() {
        router.pop()
    }
}
