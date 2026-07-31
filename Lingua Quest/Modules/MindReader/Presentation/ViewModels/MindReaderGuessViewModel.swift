//
//  MindReaderGuessViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation
import Combine

@MainActor
@Observable
final class MindReaderGuessViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    
    var guessedWord = "MANZANA"
    var guessedEmoji = "🍎"
    
    init(router: RouterProtocol, statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func onListenTapped() {
        // Text to speech logic
    }
    
    func onYesGotItTapped() {
        // Handle win
    }
    
    func onNoWrongTapped() {
        // Handle continue or lose
    }
    
    func goBack() {
        router.pop()
    }
}
