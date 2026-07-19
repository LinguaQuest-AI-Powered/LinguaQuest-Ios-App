//
//  CameraResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Foundation
import Observation

enum CameraResultState {
    case loading
    case success
    case failure
}

@Observable
@MainActor
final class CameraResultViewModel {
    let targetWord: String
    var state: CameraResultState = .loading
    
    // For successful states
    let xpPoints: Int = 10
    let coinsEarned: Int = 5
    let currentLevelProgress: Double = 0.8 // 80% for demonstration
    let currentLevelIndex: Int = 12
    
    private let router: RouterProtocol
    
    init(targetWord: String, router: RouterProtocol) {
        self.targetWord = targetWord
        self.router = router
        
        simulateAPI()
    }
    
    private func simulateAPI() {
        Task {
            // Simulate processing time
            try? await Task.sleep(nanoseconds:10_000_000_000)
            
            // Randomly succeed or fail for testing/demonstration
            self.state = Bool.random() ? .success : .failure
        }
    }
    
    func onRetryTapped() {
        router.pop()
    }
    
    func onChangeWordTapped() {
        // According to our game flow, maybe go back to level details or map
        router.popToRoot()
    }
    
    func onNextLevelTapped() {
        // Move to the next task or root
        router.popToRoot()
    }
}
