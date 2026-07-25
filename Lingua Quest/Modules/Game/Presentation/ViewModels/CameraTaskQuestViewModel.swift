//
//  CameraTaskQuestViewModel.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import Foundation
import Observation
import AVFoundation

@MainActor
@Observable
class CameraTaskQuestViewModel {
    private let router: RouterProtocol
    
    private let statsService: StatsServiceProtocol
    
    var levelId: Int
    var targetWord: String
    
    var coins: Int {
        statsService.coins
    }
    
    init(router: RouterProtocol, statsService: StatsServiceProtocol, levelId: Int = 3, targetWord: String = "PAN") {
        self.router = router
        self.statsService = statsService
        self.levelId = levelId
        self.targetWord = targetWord
    }
    
    func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            router.push(.cameraCapture(targetWord: targetWord))
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        guard let self = self else { return }
                        self.router.push(.cameraCapture(targetWord: self.targetWord))
                    }
                }
            }
        default:
            // Show alert or handle denied state
            break
        }
    }
    
    // Add logic here later like request camera permissions, analyze frame, etc.
    func onCaptureSuccess(capturedWord: WordCardEntity) {
        router.push(.wordInsight(word: capturedWord))
    }
}
