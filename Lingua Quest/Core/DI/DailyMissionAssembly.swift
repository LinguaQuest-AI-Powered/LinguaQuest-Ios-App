//
//  DailyMissionAssembly.swift
//  Lingua Quest
//
//  Created by siam on 09/08/2026.
//

import Foundation
import Swinject

@MainActor
final class DailyMissionAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Data Layer

        container.register(DailyMissionRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return DailyMissionRemoteDataSource(apiClient: apiClient)
        }

        container.register(DailyMissionRepositoryProtocol.self) { resolver in
            let remoteDS = resolver.resolve(DailyMissionRemoteDataSourceProtocol.self)!
            return DailyMissionRepositoryImpl(remoteDataSource: remoteDS)
        }

        // MARK: - Domain Layer

        container.register(GetDailyMissionUseCase.self) { resolver in
            let repo = resolver.resolve(DailyMissionRepositoryProtocol.self)!
            return GetDailyMissionUseCase(repository: repo)
        }

        container.register(VerifyDailyMissionUseCase.self) { resolver in
            let repo = resolver.resolve(DailyMissionRepositoryProtocol.self)!
            return VerifyDailyMissionUseCase(repository: repo)
        }

        // MARK: - Presentation Layer

        container.register(DailyMissionCardViewModel.self) { resolver in
            let getMissionUseCase = resolver.resolve(GetDailyMissionUseCase.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            return DailyMissionCardViewModel(getMissionUseCase: getMissionUseCase, router: router)
        }

        container.register(DailyMissionCaptureViewModel.self) { (resolver, word: String) in
            let router = resolver.resolve(RouterProtocol.self)!
            let soundPlayer = resolver.resolve(AppSoundPlayer.self)!
            return DailyMissionCaptureViewModel(targetWord: word, router: router, soundPlayer: soundPlayer)
        }

        container.register(DailyMissionResultViewModel.self) { (resolver, word: String, imageData: Data?) in
            let verifyUseCase = resolver.resolve(VerifyDailyMissionUseCase.self)!
            let statsService = resolver.resolve(StatsServiceProtocol.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            let soundPlayer = resolver.resolve(AppSoundPlayer.self)!
            return DailyMissionResultViewModel(
                targetWord: word,
                imageData: imageData,
                verifyUseCase: verifyUseCase,
                statsService: statsService,
                router: router,
                soundPlayer: soundPlayer
            )
        }
    }
}
