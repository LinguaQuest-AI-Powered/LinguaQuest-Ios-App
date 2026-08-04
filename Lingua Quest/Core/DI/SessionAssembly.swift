//
//  SessionAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Swinject

final class SessionAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SessionManagerProtocol.self) { resolver in
            SessionManager(
                router: resolver.resolve(RouterProtocol.self)!,
                tokenStorage: resolver.resolve(SecureTokenStorageProtocol.self)!,
                userPreferences: resolver.resolve(UserPreferencesProtocol.self)!,
                statsService: resolver.resolve(StatsServiceProtocol.self)!,
                logoutUseCase: resolver.resolve(LogoutUseCaseProtocol.self)!,
                unregisterDeviceUseCase: resolver.resolve(UnregisterDeviceUseCaseProtocol.self)!
            )
        }.inObjectScope(.container)
    }
}
