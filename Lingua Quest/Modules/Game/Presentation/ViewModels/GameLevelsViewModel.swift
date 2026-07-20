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
    
    private let getGameLevelsUseCase: GetGameLevelsUseCase
    
    init(getGameLevelsUseCase: GetGameLevelsUseCase) {
        self.getGameLevelsUseCase = getGameLevelsUseCase
    }
    
    func fetchLevels(worldId: Int) async {
        do {
            levels = try await getGameLevelsUseCase.execute(worldId: worldId)
        } catch {
            print("Error fetching levels: \(error)")
        }
    }
}
