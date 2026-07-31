//
//  MindReaderGameViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation
import Combine

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
    
    // Progress Data
    var currentQuestionIndex = 20
    var totalQuestions = 20
    var progressPercentage: Int {
        Int((Double(currentQuestionIndex) / Double(totalQuestions)) * 100)
    }
    
    // Game Data
    var questionText = "¿SE ENCUENTRA EN LA COCINA?"
    var birdState: MindReaderBirdState = .normal
    
    // Disable buttons while processing
    var isProcessing = false
    
    init(router: RouterProtocol, statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func onAnswerTapped(_ answer: String) {
        guard !isProcessing else { return }
        isProcessing = true
        
        // Show thinking state
        birdState = .thinking
        
        Task {
            // Fake delay for thinking
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            // Show pointing/success state (just as an example, logic will depend on actual engine)
            birdState = .pointing
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Advance question and go back to normal
            if currentQuestionIndex < totalQuestions {
                currentQuestionIndex += 1
                birdState = .normal
                isProcessing = false
            } else {
                // If this is the last question or we are forcing the guess:
                isProcessing = false
                router.push(.mindReaderGuess)
            }
        }
    }
    
    func onTranslateTapped() {
        // Translation logic
    }
    
    func onListenTapped() {
        // Text to speech logic
    }
    
    func goBack() {
        router.pop()
    }
}
