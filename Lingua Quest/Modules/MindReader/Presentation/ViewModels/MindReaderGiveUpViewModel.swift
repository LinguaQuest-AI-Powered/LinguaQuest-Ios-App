//
//  MindReaderGiveUpViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderGiveUpViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var categoryName: String {
        coordinator.selectedCategory?.targetName ?? "Kitchen"
    }
    
    var claimedWordInput: String = ""
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
    }
    
    func onSubmitTapped() {
        let word = claimedWordInput.trimmingCharacters(in: .whitespaces)
        guard !word.isEmpty else { return }
        
        Task {
            let isHonest = await coordinator.validateGiveUp(claimedWord: word)
            if isHonest {
                router.push(.mindReaderResult)
            } else {
                router.push(.mindReaderFailure)
            }
        }
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
