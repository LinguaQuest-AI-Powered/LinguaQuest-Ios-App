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
    let worldName: String
    let levelId: Int
    let levelOrder: Int
    let targetWord: String
    let cameraManager: CameraManager
    private let router: RouterProtocol
    
    init(worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String, router: RouterProtocol) {
        self.worldId = worldId
        self.worldName = worldName
        self.levelId = levelId
        self.levelOrder = levelOrder
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
        Task {
            if let image = await cameraManager.capturePhoto() {
                cameraManager.stopSession()
                let imageData = image.jpegData(compressionQuality: 0.8)
                router.push(.cameraResult(worldId: worldId, worldName: worldName, levelId: levelId, levelOrder: levelOrder, targetWord: targetWord, imageData: imageData))
            } else {
                cameraManager.stopSession()
                router.push(.cameraResult(worldId: worldId, worldName: worldName, levelId: levelId, levelOrder: levelOrder, targetWord: targetWord, imageData: nil))
            }
        }
    }
}
