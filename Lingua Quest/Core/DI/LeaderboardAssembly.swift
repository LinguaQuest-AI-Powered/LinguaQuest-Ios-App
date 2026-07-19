//
//  LeaderboardAssembly.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Swinject

final class LeaderboardAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LeaderboardViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return LeaderboardViewModel(router: router)
        }
    }
}
