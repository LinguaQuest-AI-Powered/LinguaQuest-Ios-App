//
//  CameraResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Foundation
import Observation

enum CameraResultState: Equatable {
    case loading
    case match
    case notMatch
    case error(message: String)
}

@Observable
@MainActor
final class CameraResultViewModel {
    let targetWord: String
    var state: CameraResultState = .loading
    
    // For successful states
    var xpPoints: Int = 0
    var coinsEarned: Int = 0
    var currentLevelProgress: Double = 0.0
    var currentLevelIndex: Int = 0
    
    let imageData: Data?
    private let saveUseCase: SaveCapturedItemUseCase
    private let router: RouterProtocol
    
    init(targetWord: String, imageData: Data?, saveUseCase: SaveCapturedItemUseCase, router: RouterProtocol) {
        self.targetWord = targetWord
        self.imageData = imageData
        self.saveUseCase = saveUseCase
        self.router = router
        
        simulateAPI()
    }
    
    private func simulateAPI() {
        Task {
            // Simulate processing time
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            // Randomly succeed, fail (notMatch), or API error for testing/demonstration
            let rand = Int.random(in: 0...2)
            
            if rand == 0 {
                self.xpPoints = 50
                self.coinsEarned = 10
                self.currentLevelIndex = 4
                self.currentLevelProgress = 0.85
                self.state = .match
            } else if rand == 1 {
                self.state = .notMatch
            } else {
                self.state = .error(message: "Validation error - one or more fields are missing or malformed")
            }
            
            // Save the captured item if matched
            if case .match = self.state {
                let item = CapturedItem(
                    id: UUID(),
                    englishName: self.targetWord,
                    translatedName: self.targetWord,
                    category: "GAME",
                    imageData: self.imageData,
                    isCorrect: true,
                    timestamp: Date()
                )
                
                do {
                    try await saveUseCase.execute(item: item)
                } catch {
                    print("Failed to save capture: \(error)")
                }
            }
        }
    }
    
    func onRetryTapped() {
        router.pop()
    }
    
    func onChangeWordTapped() {
        // Go back to CameraTaskQuestView (pop result and capture views)
        router.pop(count: 2)
    }
    
    func onNextLevelTapped() {
        // Go back to GameLevelsView (pop result, capture, and quest views)
        router.pop(count: 3)
    }
}
