//
//  MindReaderResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderResultViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var earnedXP: Int {
        coordinator.xpEarned
    }
    
    var earnedCoins: Int {
        coordinator.coinsEarned
    }
    
    var hasAwarded = false
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
    }
    
    /// Awards coins and XP on first appear
    func onAppear() {
        guard !hasAwarded else { return }
        hasAwarded = true
        
        Task {
            // Award coins and XP via StatsService
            try? await statsService.addCoins(earnedCoins)
            try? await statsService.addXP(earnedXP)
        }
    }
    
    func onPlayAgainTapped() {
        coordinator.reset()
        router.pop(count: 4)
    }
    
    func onBackToMenuTapped() {
        coordinator.reset()
        router.popToRoot()
    }
    
    func goBack() {
        coordinator.reset()
        router.popToRoot()
    }
}
