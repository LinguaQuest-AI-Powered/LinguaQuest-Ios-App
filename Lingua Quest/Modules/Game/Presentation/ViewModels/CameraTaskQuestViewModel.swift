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
    
    var levelId: Int
    var targetWord: String
    var coins: Int
    private let router: RouterProtocol
    
    init(router: RouterProtocol, levelId: Int = 3, targetWord: String = "PAN", coins: Int = 1250) {
        self.router = router
        self.levelId = levelId
        self.targetWord = targetWord
        self.coins = coins
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
}
