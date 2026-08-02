//
//  MindReaderGameViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

enum MindReaderBirdState {
    case normal
    case thinking
    case pointing
}

@MainActor
@Observable
final class MindReaderGameViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // Translation lifeline cost
    let translateCost = 5
    
    // Bird animation state
    var birdState: MindReaderBirdState = .normal
    
    // Processing guard
    var isProcessing = false
    
    // Translation lifeline state
    var showTranslation = false
    var showTranslateConfirmDialog = false
    var showNotEnoughCoinsDialog = false
    
    // MARK: - Computed Properties (from Coordinator)
    
    var canTranslate: Bool {
        let appLangCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        let nativeLanguage = appLangCode == "ar" ? "Arabic" : "English"
        let targetLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.targetLanguageName) ?? "Spanish"
        return nativeLanguage.lowercased() != targetLanguage.lowercased()
    }
    
    var questionText: String {
        coordinator.currentQuestionTarget ?? ""
    }
    
    var translationText: String {
        coordinator.currentQuestionNative ?? ""
    }
    
    var currentQuestionIndex: Int {
        coordinator.questionCount + 1
    }
    
    var totalQuestions: Int {
        20 // Assuming 20 is the max or typical questions, as we don't have availableAttributes count anymore.
    }
    
    var progressPercentage: Int {
        Int((Double(currentQuestionIndex) / Double(totalQuestions)) * 100)
    }
    
    var translateCostText: String {
        "\(translateCost)"
    }
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
    }
    
    func onAnswerTapped(_ answer: AnswerState) {
        guard !isProcessing else { return }
        isProcessing = true
        showTranslation = false
        
        // Show thinking animation
        birdState = .thinking
        
        Task {
            // Brief thinking delay for UX
            try? await Task.sleep(nanoseconds: 800_000_000)
            
            let shouldGuess = await coordinator.processAnswer(answer: answer)
            
            if shouldGuess {
                // Show pointing state before navigating
                birdState = .pointing
                try? await Task.sleep(nanoseconds: 600_000_000)
                isProcessing = false
                router.push(.mindReaderGuess)
            } else {
                birdState = .normal
                isProcessing = false
            }
        }
    }
    
    func onTranslateTapped() {
        guard !showTranslation else { return }
        
        if statsService.coins < translateCost {
            showNotEnoughCoinsDialog = true
            return
        }
        
        showTranslateConfirmDialog = true
    }
    
    func confirmTranslation() {
        Task {
            try? await statsService.deductCoins(translateCost)
            showTranslation = true
            coordinator.translationRevealed = true
            showTranslateConfirmDialog = false
        }
    }
    
    func onListenTapped() {
        // Text-to-speech logic - future enhancement
    }
    
    func goBack() {
        router.pop()
    }
}
