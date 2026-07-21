//
//  VoiceGameResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI
import Observation

enum VoiceGameResultState {
    case evaluating
    case success
    case failure
}

@MainActor
@Observable
final class VoiceGameResultViewModel {
    var state: VoiceGameResultState = .evaluating
    var rating: Int = 0
    var words: [WordResult] = []
    var xpPoints: Int = 0
    var coinsEarned: Int = 0
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
        startEvaluation()
    }
    
    private func startEvaluation() {
        state = .evaluating
        
        // Mock evaluation process
        Task {
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            
            // Mock result (randomly success or failure for demonstration)
            let isSuccess = Bool.random()
            
            if isSuccess {
                self.rating = 8
                self.words = [
                    WordResult(word: "The", isCorrect: true),
                    WordResult(word: "apple", isCorrect: true),
                    WordResult(word: "is", isCorrect: true),
                    WordResult(word: "red", isCorrect: true)
                ]
                self.xpPoints = 150
                self.coinsEarned = 20
                self.state = .success
            } else {
                self.rating = 4
                self.words = [
                    WordResult(word: "The", isCorrect: true),
                    WordResult(word: "apple", isCorrect: false), // red
                    WordResult(word: "is", isCorrect: true),
                    WordResult(word: "red", isCorrect: false) // red
                ]
                self.state = .failure
            }
        }
    }
    
    func onContinue() {
        router.popToRoot()
    }
    
    func onReturnHome() {
        router.popToRoot()
    }
    
    func onRetry() {
        // Pop back to the game to retry
        router.pop()
    }
}
