//
//  DailyMissionCaptureViewModel.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation
import Observation
import UIKit

@Observable
@MainActor
final class DailyMissionCaptureViewModel {
    let targetWord: String
    let cameraManager: CameraManager
    private let router: RouterProtocol
    private let soundPlayer: AppSoundPlayer

    init(targetWord: String, router: RouterProtocol, soundPlayer: AppSoundPlayer) {
        self.targetWord = targetWord
        self.router = router
        self.soundPlayer = soundPlayer
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
        soundPlayer.play(sound: .camera)
        Task {
            let image = await cameraManager.capturePhoto()
            cameraManager.stopSession()
            let imageData = image?.jpegData(compressionQuality: 0.8)
            router.push(.dailyMissionResult(word: targetWord, imageData: imageData))
        }
    }
}
