//
//  StorageAssembly.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Swinject

final class StorageAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserPreferencesProtocol.self) { _ in
            UserPreferences()
        }.inObjectScope(.container)
    }
}
