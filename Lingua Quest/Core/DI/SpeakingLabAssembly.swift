//
//  SpeakingLabAssembly.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Swinject

@MainActor
final class SpeakingLabAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VoiceGameViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return VoiceGameViewModel(router: router)
        }
    }
}
