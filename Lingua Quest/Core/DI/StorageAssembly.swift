//
//  StorageAssembly.swift
//  Lingua Quest
//

import Swinject

final class StorageAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserPreferences.self) { _ in
            UserPreferences()
        }.inObjectScope(.container)
        
        container.register(UserPreferencesProtocol.self) { resolver in
            resolver.resolve(UserPreferences.self)!
        }

        container.register(SecureTokenStorageProtocol.self) { _ in
            SecureTokenStorage()
        }.inObjectScope(.container)
    }
}
