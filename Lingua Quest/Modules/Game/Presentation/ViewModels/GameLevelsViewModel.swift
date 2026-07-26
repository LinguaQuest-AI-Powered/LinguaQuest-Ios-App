//
//  GameLevelsViewModel.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class GameLevelsViewModel {
    var levels: [GameLevel] = []
    var isLoading: Bool = true
    
    // Alert state
    var showError: Bool = false
    var errorMessage: String = ""
    var isStartingLevel: Bool = false
    
    private let getGameLevelsUseCase: GetGameLevelsUseCase
    private let startLevelUseCase: StartLevelUseCase
    private let router: RouterProtocol
    
    init(getGameLevelsUseCase: GetGameLevelsUseCase, startLevelUseCase: StartLevelUseCase, router: RouterProtocol) {
        self.getGameLevelsUseCase = getGameLevelsUseCase
        self.startLevelUseCase = startLevelUseCase
        self.router = router
    }
    
    func fetchLevels(worldId: Int, languageId: Int) async {
        isLoading = true
        do {
            levels = try await getGameLevelsUseCase.execute(worldId: worldId, languageId: languageId)
            
            // Allow UI to render the Shimmer state on the correct final road length for a seamless transition
            try? await Task.sleep(nanoseconds: 600_000_000)
            
        } catch {
            print("Error fetching levels: \(error)")
        }
        isLoading = false
    }
    
    func onLevelTapped(worldId: Int, level: GameLevel) {
        guard level.status != .locked else { return }
        
        isStartingLevel = true
        Task {
            do {
                let entity = try await startLevelUseCase.execute(worldId: worldId, levelId: level.id)
                router.push(.cameraQuestTask(worldId: worldId, levelId: level.id, targetWord: entity.targetWord))
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
            isStartingLevel = false
        }
    }
}
