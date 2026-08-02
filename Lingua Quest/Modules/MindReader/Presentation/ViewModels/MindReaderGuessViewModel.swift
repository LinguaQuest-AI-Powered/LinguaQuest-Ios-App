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
    
    // MARK: - Computed Properties (from Coordinator)
    
    var guessedWord: String {
        coordinator.bestGuess?.word ?? ""
    }
    
    var guessedEmoji: String {
        coordinator.bestGuess?.emoji ?? "❓"
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
    
    func onListenTapped() {
        // Text-to-speech logic - future enhancement
    }
    
    func onYesGotItTapped() {
        Task {
            await coordinator.requestQuiz()
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
