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
    
    private let getGameLevelsUseCase: GetGameLevelsUseCase
    
    init(getGameLevelsUseCase: GetGameLevelsUseCase) {
        self.getGameLevelsUseCase = getGameLevelsUseCase
    }
    
    func fetchLevels(worldId: Int) async {
        isLoading = true
        do {
            levels = try await getGameLevelsUseCase.execute(worldId: worldId)
            
            // Allow UI to render the Shimmer state on the correct final road length for a seamless transition
            try? await Task.sleep(nanoseconds: 600_000_000)
            
        } catch {
            print("Error fetching levels: \(error)")
        }
        isLoading = false
    }
}
