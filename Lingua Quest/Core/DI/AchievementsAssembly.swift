//
//  AchievementsAssembly.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Swinject

final class AchievementsAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AchievementsRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return AchievementsRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(AchievementsRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(AchievementsRemoteDataSourceProtocol.self)!
            return AchievementsRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetAchievementsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(AchievementsRepositoryProtocol.self)!
            return GetAchievementsUseCase(repository: repository)
        }
        
        container.register(GetWeeklyRewardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(AchievementsRepositoryProtocol.self)!
            return GetWeeklyRewardUseCase(repository: repository)
        }
        
        container.register(ClaimWeeklyRewardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(AchievementsRepositoryProtocol.self)!
            return ClaimWeeklyRewardUseCase(repository: repository)
        }
        
        container.register(AchievementsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getAchievementsUseCase = resolver.resolve(GetAchievementsUseCaseProtocol.self)!
            let getWeeklyRewardUseCase = resolver.resolve(GetWeeklyRewardUseCaseProtocol.self)!
            let claimWeeklyRewardUseCase = resolver.resolve(ClaimWeeklyRewardUseCaseProtocol.self)!
            
            return AchievementsViewModel(
                router: router,
                getAchievementsUseCase: getAchievementsUseCase,
                getWeeklyRewardUseCase: getWeeklyRewardUseCase,
                claimWeeklyRewardUseCase: claimWeeklyRewardUseCase
            )
        }
    }
}
