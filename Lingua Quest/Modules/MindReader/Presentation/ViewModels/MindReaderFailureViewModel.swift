//
//  MindReaderFailureViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderFailureViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var failureReason: String {
        coordinator.failureReason ?? L10n.MindReader.bustedDefaultReason
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
    
    func onAppear() {
        // Any specific failure logic if needed
    }
    
    func onTryAgainTapped() {
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
