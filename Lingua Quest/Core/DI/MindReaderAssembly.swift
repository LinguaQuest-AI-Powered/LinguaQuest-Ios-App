//
//  MindReaderAssembly.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Swinject

@MainActor
final class MindReaderAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Data Sources
        
        container.register(MindReaderLocalDataSourceProtocol.self) { _ in
            MindReaderLocalDataSource()
        }.inObjectScope(.container)
        
        container.register(MindReaderRemoteDataSourceProtocol.self) { r in
            let apiClient = r.resolve(APIClientProtocol.self)!
            return MindReaderRemoteDataSource(apiClient: apiClient)
        }.inObjectScope(.container)
        
        // MARK: - Repository
        
        container.register(MindReaderRepositoryProtocol.self) { r in
            let localDS = r.resolve(MindReaderLocalDataSourceProtocol.self)!
            let remoteDS = r.resolve(MindReaderRemoteDataSourceProtocol.self)
            return MindReaderRepositoryImpl(localDataSource: localDS, remoteDataSource: remoteDS)
        }.inObjectScope(.container)
        
        // MARK: - Use Cases
        
        container.register(InitializeGameUseCase.self) { r in
            let repo = r.resolve(MindReaderRepositoryProtocol.self)!
            return InitializeGameUseCase(repository: repo)
        }
        
        container.register(CalculateNextQuestionUseCase.self) { _ in
            CalculateNextQuestionUseCase()
        }
        
        container.register(ProcessUserAnswerUseCase.self) { _ in
            ProcessUserAnswerUseCase()
        }
        
        container.register(ValidateHonestyUseCase.self) { _ in
            ValidateHonestyUseCase()
        }
        
        // MARK: - Game Coordinator (Shared across all MindReader screens)
        
        container.register(MindReaderGameCoordinator.self) { r in
            MindReaderGameCoordinator(
                initializeGameUseCase: r.resolve(InitializeGameUseCase.self)!,
                calculateNextQuestionUseCase: r.resolve(CalculateNextQuestionUseCase.self)!,
                processUserAnswerUseCase: r.resolve(ProcessUserAnswerUseCase.self)!,
                validateHonestyUseCase: r.resolve(ValidateHonestyUseCase.self)!,
                repository: r.resolve(MindReaderRepositoryProtocol.self)!
            )
        }.inObjectScope(.container)
        
        // MARK: - ViewModels
        
        container.register(MindReaderIntroViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderIntroViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderGameViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderGameViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderGuessViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderGuessViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderTranslationViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderTranslationViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderResultViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderResultViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderFailureViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderFailureViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
        
        container.register(MindReaderGiveUpViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            let coordinator = r.resolve(MindReaderGameCoordinator.self)!
            return MindReaderGiveUpViewModel(router: router, statsService: statsService, coordinator: coordinator)
        }
    }
}
