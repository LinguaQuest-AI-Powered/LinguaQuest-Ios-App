//
//  MindReaderIntroViewModel.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderIntroViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator

    var showReadyDialog = false
    var isLoadingGame = false
    
    var currentCategoryName: String {
        coordinator.availableCategories.first?.targetName ?? "Kitchen"
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
        Task {
            try? await statsService.fetchStats()
            coordinator.loadCategories()
        }
    }
    
    func onStartGameTapped() {
        showReadyDialog = true
    }
    
    func onChangeCategoryTapped() {
        // Category change - future enhancement
    }
    
    func onNotYetTapped() {
        showReadyDialog = false
    }
    
    func onYesLetsGoTapped() {
        guard let category = coordinator.availableCategories.first else { return }
        showReadyDialog = false
        isLoadingGame = true
        
        Task {
            await coordinator.initializeGame(category: category)
            isLoadingGame = false
            router.push(.mindReaderGame)
        }
    }
    
    func goBack() {
        router.pop()
    }
}
