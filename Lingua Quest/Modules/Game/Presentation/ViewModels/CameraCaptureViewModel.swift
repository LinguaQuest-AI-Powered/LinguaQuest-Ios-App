//
//  CameraCaptureViewModel.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Foundation
import Observation
import UIKit

@Observable
@MainActor
final class CameraCaptureViewModel {
    let worldId: Int
    let levelId: Int
    let targetWord: String
    let cameraManager: CameraManager
    private let router: RouterProtocol
    
    init(worldId: Int, levelId: Int, targetWord: String, router: RouterProtocol) {
        self.worldId = worldId
        self.levelId = levelId
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
        let imageData = cameraManager.capturedImage?.jpegData(compressionQuality: 0.8)
        router.push(.cameraResult(worldId: worldId, levelId: levelId, targetWord: targetWord, imageData: imageData))
    }
}
