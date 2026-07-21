//
//  LeaderboardAssembly.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import Swinject

final class LeaderboardAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LeaderboardRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return LeaderboardRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(LeaderboardRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(LeaderboardRemoteDataSourceProtocol.self)!
            return LeaderboardRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetLeaderboardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(LeaderboardRepositoryProtocol.self)!
            return GetLeaderboardUseCase(repository: repository)
        }
        
        container.register(LeaderboardViewModel.self) { (resolver, languageId: Int) in
            let router = resolver.resolve(RouterProtocol.self)!
            let getLeaderboardUseCase = resolver.resolve(GetLeaderboardUseCaseProtocol.self)!
            return LeaderboardViewModel(router: router, getLeaderboardUseCase: getLeaderboardUseCase, languageId: languageId)
        }
    }
}
