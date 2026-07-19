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
        
        container.register(CameraTaskQuestViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return CameraTaskQuestViewModel(router: router)
        }
    }
}
