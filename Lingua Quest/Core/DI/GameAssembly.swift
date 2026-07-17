//
//  GameAssembly.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//


import Swinject

@MainActor
final class GameAssembly: Assembly { 
    func assemble(container: Container) {
        container.register(GameLevelsViewModel.self) { _ in
            GameLevelsViewModel()
        }
    }
}
