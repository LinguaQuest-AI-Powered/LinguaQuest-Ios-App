//
//  CameraTaskQuestViewModel.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class CameraTaskQuestViewModel {
    private let router: RouterProtocol
    
    var levelId: Int
    var targetWord: String
    var coins: Int
    
    init(router: RouterProtocol, levelId: Int = 3, targetWord: String = "PAN", coins: Int = 1250) {
        self.router = router
        
        self.levelId = levelId
        self.targetWord = targetWord
        self.coins = coins
    }
    
    // Add logic here later like request camera permissions, analyze frame, etc.
    
    func onCaptureSuccess(capturedWord: WordCardEntity) {
        
        router.push(.wordInsight(word: capturedWord))
    }
}
