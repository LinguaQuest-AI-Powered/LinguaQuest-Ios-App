//
//  HomeAssembly.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Swinject

final class HomeAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(HomeRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return HomeRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(HomeRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(HomeRemoteDataSourceProtocol.self)!
            return HomeRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetHomeDataUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetHomeDataUseCase(repository: repository)
        }
        
        container.register(GetHomeWorldsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetHomeWorldsUseCase(repository: repository)
        }
        
        container.register(GetDailyRewardUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetDailyRewardUseCase(repository: repository)
        }
        
        container.register(ClaimDailyRewardUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return ClaimDailyRewardUseCase(repository: repository)
        }
        
        container.register(DailyRewardViewModel.self) { resolver in
            let getDailyRewardUseCase = resolver.resolve(GetDailyRewardUseCase.self)!
            let claimDailyRewardUseCase = resolver.resolve(ClaimDailyRewardUseCase.self)!
            return DailyRewardViewModel(getDailyRewardUseCase: getDailyRewardUseCase, claimDailyRewardUseCase: claimDailyRewardUseCase)
        }
        
        container.register(HomeViewModel.self) { resolver in
            let getHomeDataUseCase = resolver.resolve(GetHomeDataUseCaseProtocol.self)!
            let getHomeWorldsUseCase = resolver.resolve(GetHomeWorldsUseCaseProtocol.self)!
            let dailyRewardViewModel = resolver.resolve(DailyRewardViewModel.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            return HomeViewModel(
                getHomeDataUseCase: getHomeDataUseCase,
                getHomeWorldsUseCase: getHomeWorldsUseCase,
                dailyRewardViewModel: dailyRewardViewModel,
                router: router
            )
        }
    }
}
