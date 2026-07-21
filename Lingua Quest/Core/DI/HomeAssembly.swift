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
        
        container.register(HomeViewModel.self) { resolver in
            let useCase = resolver.resolve(GetHomeDataUseCaseProtocol.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            return HomeViewModel(getHomeDataUseCase: useCase, router: router)
        }
    }
}
