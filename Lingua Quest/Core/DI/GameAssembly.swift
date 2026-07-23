//
//  GameAssembly.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//


import Foundation
import Swinject

@MainActor
final class GameAssembly: Assembly { 
    func assemble(container: Container) {
        container.register(GameRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return GameRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(GameRepositoryProtocol.self) { resolver in
            let remoteDS = resolver.resolve(GameRemoteDataSourceProtocol.self)!
            return GameRepositoryImpl(remoteDataSource: remoteDS)
        }
        
        container.register(GetGameLevelsUseCase.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return GetGameLevelsUseCase(repository: repo)
        }
        
        container.register(GameLevelsViewModel.self) { resolver in
            let useCase = resolver.resolve(GetGameLevelsUseCase.self)!
            return GameLevelsViewModel(getGameLevelsUseCase: useCase)
        }
        
        container.register(CameraTaskQuestViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return CameraTaskQuestViewModel(router: router)
        }
        
        container.register(CameraCaptureViewModel.self) { (resolver, targetWord: String) in
            let router = resolver.resolve(RouterProtocol.self)!
            return CameraCaptureViewModel(targetWord: targetWord, router: router)
        }
        
        container.register(CameraResultViewModel.self) { (resolver, targetWord: String, imageData: Data?) in
            let router = resolver.resolve(RouterProtocol.self)!
            let saveUseCase = resolver.resolve(SaveCapturedItemUseCase.self)!
            return CameraResultViewModel(targetWord: targetWord, imageData: imageData, saveUseCase: saveUseCase, router: router)
        }
    }
}
