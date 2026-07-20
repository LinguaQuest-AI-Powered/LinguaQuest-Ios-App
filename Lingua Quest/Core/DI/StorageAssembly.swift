//
//  StorageAssembly.swift
//  Lingua Quest
//

import Swinject

final class StorageAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserPreferencesProtocol.self) { _ in
            UserPreferences()
        }.inObjectScope(.container)

        container.register(SecureTokenStorageProtocol.self) { _ in
            SecureTokenStorage()
        }.inObjectScope(.container)
    }
}
