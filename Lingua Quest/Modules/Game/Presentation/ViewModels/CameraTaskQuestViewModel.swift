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
    
    var worldId: Int
    var worldName: String
    var levelId: Int
    var levelOrder: Int
    var targetWord: String
    
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""
    var hintText: String? = nil
    
    var coins: Int {
        statsService.coins
    }
    
    private let getHintUseCase: GetHintUseCase
    private let changeWordUseCase: ChangeWordUseCase
    private let speechSynthesizer: SpeechSynthesizerProtocol
    
    init(router: RouterProtocol, statsService: StatsServiceProtocol, getHintUseCase: GetHintUseCase, changeWordUseCase: ChangeWordUseCase, speechSynthesizer: SpeechSynthesizerProtocol, worldId: Int = 1, worldName: String = "World", levelId: Int = 3, levelOrder: Int = 1, targetWord: String = "PAN") {
        self.router = router
        self.statsService = statsService
        self.getHintUseCase = getHintUseCase
        self.changeWordUseCase = changeWordUseCase
        self.speechSynthesizer = speechSynthesizer
        self.worldId = worldId
        self.worldName = worldName
        self.levelId = levelId
        self.levelOrder = levelOrder
        self.targetWord = targetWord
    }
    
    func onHintSelected() {
        isLoading = true
        Task {
            do {
                let entity = try await getHintUseCase.execute(worldId: worldId, levelId: levelId)
                self.hintText = entity.hint
                self.statsService.syncBalances(coins: entity.remainingCoins, xp: self.statsService.xp, streakDays: nil)
            } catch let error as NetworkError {
                if let message = error.apiErrorMessage {
                    self.errorMessage = message
                } else {
                    self.errorMessage = error.localizedDescription
                }
                self.showError = true
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
            isLoading = false
        }
    }
    
    func onChangeWordTapped() {
        isLoading = true
        Task {
            do {
                let entity = try await changeWordUseCase.execute(worldId: worldId, levelId: levelId)
                self.targetWord = entity.targetWord
                // For change word, API returns the new coin balance in response
                self.statsService.syncBalances(coins: entity.coins, xp: self.statsService.xp, streakDays: nil)
            } catch let error as NetworkError {
                if let message = error.apiErrorMessage {
                    self.errorMessage = message
                } else {
                    self.errorMessage = error.localizedDescription
                }
                self.showError = true
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
            isLoading = false
        }
    }
    
    func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            router.push(.cameraCapture(worldId: worldId, worldName: worldName, levelId: levelId, levelOrder: levelOrder, targetWord: targetWord))
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        guard let self = self else { return }
                        self.router.push(.cameraCapture(worldId: self.worldId, worldName: self.worldName, levelId: self.levelId, levelOrder: self.levelOrder, targetWord: self.targetWord))
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
    
    func playAudio() {
        // Play the target word. In a real app we'd pass the active language code
        // Defaulting to Spanish "es" if it's a Spanish learning app, or fallback to en
        speechSynthesizer.speak(text: targetWord, languageCode: "es")
    }
}
