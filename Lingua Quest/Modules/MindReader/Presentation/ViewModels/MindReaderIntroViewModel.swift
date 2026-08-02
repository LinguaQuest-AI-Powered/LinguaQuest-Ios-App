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
    var showCategorySheet = false
    var isLoadingGame = false
    
    var selectedCategory: GameCategory?
    
    var currentCategoryName: String {
        guard let key = selectedCategory?.key ?? coordinator.availableCategories.first?.key else { return "Unknown" }
        return L10n.MindReader.categoryName(for: key)
    }
    
    var currentCategoryEmoji: String {
        selectedCategory?.emoji ?? coordinator.availableCategories.first?.emoji ?? "📦"
    }
    
    var availableCategories: [GameCategory] {
        coordinator.availableCategories
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
            if selectedCategory == nil {
                selectedCategory = coordinator.availableCategories.first
            }
        }
    }
    
    func onStartGameTapped() {
        showReadyDialog = true
    }
    
    func onChangeCategoryTapped() {
        showCategorySheet = true
    }
    
    func selectCategory(_ category: GameCategory) {
        selectedCategory = category
        showCategorySheet = false
    }
    
    func onNotYetTapped() {
        showReadyDialog = false
    }
    
    func onYesLetsGoTapped() {
        guard let category = selectedCategory ?? coordinator.availableCategories.first else { return }
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
