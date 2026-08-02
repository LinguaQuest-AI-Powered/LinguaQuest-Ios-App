//
//  MindReaderTranslationViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderTranslationViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var wordToTranslate: String {
        coordinator.bestGuess?.word ?? ""
    }
    
    var options: [String] {
        coordinator.quizChoices.map(\.translationText)
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
    
    func onOptionTapped(_ option: String) {
        guard let choice = coordinator.quizChoices.first(where: { $0.translationText == option }) else { return }
        
        let isVictory = coordinator.validateQuiz(choice: choice)
        
        if isVictory {
            router.push(.mindReaderResult)
        } else {
            router.push(.mindReaderFailure)
        }
    }
    
    func goBack() {
        router.pop()
    }
}
