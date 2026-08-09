//
//  LingosViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 09/08/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class LingosViewModel {
    private let router: RouterProtocol
    private let getVoiceProgressUseCase: GetVoiceProgressUseCase
    
    var voiceCompleted: Int = 0
    var voiceTotal: Int = 5
    
    let statsService: StatsService
    
    init(
        router: RouterProtocol,
        getVoiceProgressUseCase: GetVoiceProgressUseCase,
        statsService: StatsService
    ) {
        self.router = router
        self.getVoiceProgressUseCase = getVoiceProgressUseCase
        self.statsService = statsService
    }
    
    func loadVoiceProgress() {
        Task {
            do {
                let progress = try await getVoiceProgressUseCase.execute()
                self.voiceCompleted = progress.completed
                self.voiceTotal = progress.total
            } catch {
                print("Failed to load voice progress in LingosViewModel: \(error)")
            }
        }
    }
    
    func navigateToVoiceGame() {
        router.push(.voiceGame)
    }
    
    func navigateToRoleplay() {
        router.push(.roleplayScenarios)
    }
    
    func navigateToMindReader() {
        router.push(.mindReaderIntro)
    }
}
