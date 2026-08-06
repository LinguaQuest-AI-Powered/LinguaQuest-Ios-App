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
        
        container.register(GetContinueLevelUseCaseProtocol.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return GetContinueLevelUseCase(repository: repo)
        }
        
        container.register(StartLevelUseCase.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return StartLevelUseCase(repository: repo)
        }
        
        container.register(ChangeWordUseCase.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return ChangeWordUseCase(repository: repo)
        }
        
        container.register(VerifyImageUseCase.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return VerifyImageUseCase(repository: repo)
        }
        
        container.register(GetHintUseCase.self) { resolver in
            let repo = resolver.resolve(GameRepositoryProtocol.self)!
            return GetHintUseCase(repository: repo)
        }
        
        container.register(GameLevelsViewModel.self) { resolver in
            let useCase = resolver.resolve(GetGameLevelsUseCase.self)!
            let startLevelUseCase = resolver.resolve(StartLevelUseCase.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            return GameLevelsViewModel(getGameLevelsUseCase: useCase, startLevelUseCase: startLevelUseCase, router: router)
        }
        
        container.register(CameraTaskQuestViewModel.self) { (resolver, worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String) in
            let router = resolver.resolve(RouterProtocol.self)!
            let statsService = resolver.resolve(StatsServiceProtocol.self)!
            let hintUseCase = resolver.resolve(GetHintUseCase.self)!
            let changeWordUseCase = resolver.resolve(ChangeWordUseCase.self)!
            return CameraTaskQuestViewModel(
                router: router,
                statsService: statsService,
                getHintUseCase: hintUseCase,
                changeWordUseCase: changeWordUseCase,
                worldId: worldId,
                worldName: worldName,
                levelId: levelId,
                levelOrder: levelOrder,
                targetWord: targetWord
            )
        }
        
        container.register(CameraCaptureViewModel.self) { (resolver, worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String) in
            let router = resolver.resolve(RouterProtocol.self)!
            let soundPlayer = resolver.resolve(AppSoundPlayer.self)!
            return CameraCaptureViewModel(worldId: worldId, worldName: worldName, levelId: levelId, levelOrder: levelOrder, targetWord: targetWord, router: router, soundPlayer: soundPlayer)
        }
        
        container.register(CameraResultViewModel.self) { (resolver, worldId: Int, worldName: String, levelId: Int, levelOrder: Int, targetWord: String, imageData: Data?) in
            let router = resolver.resolve(RouterProtocol.self)!
            let saveUseCase = resolver.resolve(SaveCapturedItemUseCase.self)!
            let verifyUseCase = resolver.resolve(VerifyImageUseCase.self)!
            let changeWordUseCase = resolver.resolve(ChangeWordUseCase.self)!
            let statsService = resolver.resolve(StatsServiceProtocol.self)!
            return CameraResultViewModel(
                worldId: worldId,
                worldName: worldName,
                levelId: levelId,
                levelOrder: levelOrder,
                targetWord: targetWord,
                imageData: imageData,
                saveUseCase: saveUseCase,
                verifyUseCase: verifyUseCase,
                changeWordUseCase: changeWordUseCase,
                statsService: statsService,
                router: router,
                soundPlayer: resolver.resolve(AppSoundPlayer.self)!
            )
        }
    }
}
