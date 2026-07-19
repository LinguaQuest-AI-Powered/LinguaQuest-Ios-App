//
//  CameraCaptureViewModel.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CameraCaptureViewModel {
    let targetWord: String
    let cameraManager: CameraManager
    private let router: RouterProtocol
    
    init(targetWord: String, router: RouterProtocol) {
        self.targetWord = targetWord
        self.router = router
        self.cameraManager = CameraManager()
    }
    
    func onBackTapped() {
        cameraManager.stopSession()
        router.pop()
    }
    
    func onFlashTapped() {
        cameraManager.toggleFlash()
    }
    
    func onFlipCameraTapped() {
        cameraManager.flipCamera()
    }
    
    func onCaptureTapped() {
        // Mock capture for debugging: Stop camera and push result view
        cameraManager.stopSession()
        router.push(.cameraResult(targetWord: targetWord))
    }
}
