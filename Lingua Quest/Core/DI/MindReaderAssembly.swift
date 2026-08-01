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
        container.register(MindReaderLocalDataSourceProtocol.self) { _ in
            MindReaderLocalDataSource()
        }.inObjectScope(.container)
        
        container.register(MindReaderRemoteDataSourceProtocol.self) { r in
            let apiClient = r.resolve(APIClientProtocol.self)!
            return MindReaderRemoteDataSource(apiClient: apiClient)
        }.inObjectScope(.container)
        
        container.register(MindReaderRepositoryProtocol.self) { r in
            let localDS = r.resolve(MindReaderLocalDataSourceProtocol.self)!
            let remoteDS = r.resolve(MindReaderRemoteDataSourceProtocol.self)
            return MindReaderRepositoryImpl(localDataSource: localDS, remoteDataSource: remoteDS)
        }.inObjectScope(.container)
        
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
        
        container.register(MindReaderIntroViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderIntroViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderGameViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderGameViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderGuessViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderGuessViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderTranslationViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderTranslationViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderResultViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderResultViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderFailureViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderFailureViewModel(router: router, statsService: statsService)
        }
        
        container.register(MindReaderGiveUpViewModel.self) { r in
            let statsService = r.resolve(StatsService.self)!
            let router = r.resolve(RouterProtocol.self)!
            return MindReaderGiveUpViewModel(router: router, statsService: statsService)
        }
    }
}
