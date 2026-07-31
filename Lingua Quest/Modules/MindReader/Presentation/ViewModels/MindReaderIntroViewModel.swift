//
//  MindReaderIntroViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation
import Combine

@MainActor
@Observable
final class MindReaderIntroViewModel {
    private let router: RouterProtocol
    let statsService: StatsService

    var showReadyDialog = false
    var currentCategoryName = "Kitchen"
    
    
    init(router: RouterProtocol,statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func onStartGameTapped() {
        showReadyDialog = true
    }
    
    func onChangeCategoryTapped() {
        // Handle change category
    }
    
    func onNotYetTapped() {
        showReadyDialog = false
    }
    
    func onYesLetsGoTapped() {
        showReadyDialog = false
        // router.push(...) to actual game
    }
    
    func goBack() {
        router.pop()
    }
}
