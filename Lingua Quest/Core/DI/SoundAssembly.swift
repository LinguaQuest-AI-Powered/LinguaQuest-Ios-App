//
//  SoundAssembly.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 30/07/2026.
//

import Swinject

final class SoundAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppSoundPlayer.self) { resolver in
            SoundManager(userPreferences: resolver.resolve(UserPreferences.self)!)
        }
        .inObjectScope(.container)
    }
}
