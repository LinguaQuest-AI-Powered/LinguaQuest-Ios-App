//
//  StatsAssembly.swift
//  Lingua Quest
//
//  Created by omarkhaledjaafar on 25/07/2026.
//

import Swinject

final class StatsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatsRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return StatsRemoteDataSource(apiClient: apiClient)
        }

        container.register(StatsService.self) { resolver in
            let remoteDataSource = resolver.resolve(StatsRemoteDataSourceProtocol.self)!
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            let soundPlayer = resolver.resolve(AppSoundPlayer.self)!
            return StatsService(
                remoteDataSource: remoteDataSource,
                userPreferences: userPreferences,
                soundPlayer: soundPlayer
            )
        }.inObjectScope(.container)
        
        container.register(StatsServiceProtocol.self) { resolver in
            resolver.resolve(StatsService.self)!
        }
    }
}
