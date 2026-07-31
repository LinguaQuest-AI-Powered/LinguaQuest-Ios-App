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
    let worldId: Int
    let worldName: String
    let levelId: Int
    let levelOrder: Int
    let targetWord: String
    var state: CameraResultState = .loading
    
    var coins: Int {
        statsService.coins
    }
    
    // For successful states
    var xpPoints: Int = 0
    var coinsEarned: Int = 0
    var currentLevelProgress: Double = 0.0
    var currentLevelIndex: Int = 0
    
    let imageData: Data?
    private let saveUseCase: SaveCapturedItemUseCase
    private let verifyUseCase: VerifyImageUseCase
    private let changeWordUseCase: ChangeWordUseCase
    private let statsService: StatsServiceProtocol
    private let router: RouterProtocol
    private let soundPlayer: AppSoundPlayer
    
    init(worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String, imageData: Data?, saveUseCase: SaveCapturedItemUseCase, verifyUseCase: VerifyImageUseCase, changeWordUseCase: ChangeWordUseCase, statsService: StatsServiceProtocol, router: RouterProtocol, soundPlayer: AppSoundPlayer) {
        self.worldId = worldId
        self.worldName = worldName
        self.levelId = levelId
        self.levelOrder = levelOrder
        self.targetWord = targetWord
        self.imageData = imageData
        self.saveUseCase = saveUseCase
        self.verifyUseCase = verifyUseCase
        self.changeWordUseCase = changeWordUseCase
        self.statsService = statsService
        self.router = router
        self.soundPlayer = soundPlayer
        
        verifyImage()
    }
    
    private func verifyImage() {
        guard let data = imageData else {
            self.state = .error(message: L10n.Game.noImageData)
            return
        }
        
        Task {
            do {
                let entity = try await verifyUseCase.execute(worldId: worldId, levelId: levelId, imageData: data)
                
                if entity.isMatch {
                    self.xpPoints = entity.xpEarned ?? 0
                    self.coinsEarned = entity.coinsEarned ?? 0
                    self.currentLevelIndex = entity.level ?? self.levelId
                    self.currentLevelProgress = min(max((entity.levelProgressPercentage ?? 0.0) / 100.0, 0.0), 1.0)
                    
                    self.statsService.syncBalances(coins: self.statsService.coins + self.coinsEarned, xp: self.statsService.xp + self.xpPoints, streakDays: nil)
                    
                    self.state = .match
                    soundPlayer.play(sound: .success)
                    
                    // Save the captured item locally
                    let item = CapturedItem(
                        id: UUID(),
                        englishName: self.targetWord,
                        translatedName: self.targetWord,
                        category: self.worldName.uppercased(),
                        imageData: self.imageData,
                        isCorrect: true,
                        timestamp: Date()
                    )
                    try? await saveUseCase.execute(item: item)
                } else {
                    self.state = .notMatch
                    soundPlayer.play(sound: .fail)
                }
            } catch let error as NetworkError {
                soundPlayer.play(sound: .fail)
                if let message = error.apiErrorMessage {
                    self.state = .error(message: message)
                } else {
                    self.state = .error(message: error.localizedDescription)
                }
            } catch {
                soundPlayer.play(sound: .fail)
                self.state = .error(message: error.localizedDescription)
            }
        }
    }
    
    func onRetryTapped() {
        router.pop()
    }
    
    func onChangeWordTapped() {
        state = .loading
        Task {
            do {
                let entity = try await changeWordUseCase.execute(worldId: worldId, levelId: levelId)
                self.statsService.syncBalances(coins: entity.coins, xp: self.statsService.xp, streakDays: nil)
                // We got the new word. We should pop back to QuestView, but to update the word, we use replacement push as planned.
                router.popToRoot()
                router.push(.cameraQuestTask(worldId: worldId, worldName: worldName, levelId: levelId, levelOrder: levelOrder, targetWord: entity.targetWord))
            } catch let error as NetworkError {
                if let message = error.apiErrorMessage {
                    self.state = .error(message: message)
                } else {
                    self.state = .error(message: error.localizedDescription)
                }
            } catch {
                self.state = .error(message: error.localizedDescription)
            }
        }
    }
    
    func onNextLevelTapped() {
        // Go back to GameLevelsView (pop result, capture, and quest views)
        router.pop(count: 3)
    }
}
