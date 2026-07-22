//
//  Resolver.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Swinject

final class Resolver {
    static let shared = Resolver()
    let container: Container

    private init() {
        container = Container()
        registerAssemblies()
        wireCircularDependencies()
        _ = container.resolve(SessionManagerProtocol.self) // force-instantiate to start listening for .sessionExpired
    }

    private func registerAssemblies() {
        _ = Assembler(
            [
                NetworkAssembly(), RouterAssembly(), StorageAssembly(),
                AuthAssembly(), OnboardingAssembly(), GameAssembly(), GalleryAssembly(),
                LeaderboardAssembly(), ProfileAssembly(), SettingsAssembly(),HomeAssembly(),
                WordInsightAssembly(), AllWorldsAssembly(), AchievementsAssembly(),
                SpeakingLabAssembly(),
                SessionAssembly()
            ],
            container: container
        )
    }
    
    
    /// Wires dependencies that can't be expressed through normal constructor injection
    /// because they'd create a circular object graph at registration time.
    /// Currently: APIClient <-> AuthTokenProvider <-> AuthRemoteDataSource(APIClient).
    private func wireCircularDependencies() {
        guard let apiClient = container.resolve(APIClientProtocol.self) as? APIClient else { return }
        apiClient.tokenProvider = container.resolve(AuthTokenProviding.self)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let service = container.resolve(type) else {
            fatalError("Failed to resolve type: \(type)")
        }
        return service
    }
    
    func resolve<T, Arg1>(_ type: T.Type, argument: Arg1) -> T {
        guard let service = container.resolve(type, argument: argument) else {
            fatalError("Failed to resolve type: \(type) with argument: \(argument)")
        }
        return service
    }
}
