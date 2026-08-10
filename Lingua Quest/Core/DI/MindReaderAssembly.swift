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
        
        container.register(MindReaderCategoriesLocalDataSourceProtocol.self) { _ in
            MindReaderCategoriesLocalDataSource()
        }.inObjectScope(.container)
        
        container.register(MindReaderRemoteDataSourceProtocol.self) { r in
            let apiClient = r.resolve(APIClientProtocol.self)!
            return MindReaderRemoteDataSource(apiClient: apiClient)
        }.inObjectScope(.container)
        
        // MARK: - Repository
        
        container.register(MindReaderRepositoryProtocol.self) { r in
            let localDS = r.resolve(MindReaderCategoriesLocalDataSourceProtocol.self)!
            let remoteDS = r.resolve(MindReaderRemoteDataSourceProtocol.self)!
            return MindReaderRepositoryImpl(localDataSource: localDS, remoteDataSource: remoteDS)
        }.inObjectScope(.container)
        
        // MARK: - Use Cases
        
        container.register(GetCategoriesUseCase.self) { r in
            let repo = r.resolve(MindReaderRepositoryProtocol.self)!
            return GetCategoriesUseCase(repository: repo)
        }
        
        container.register(RequestNextGameStepUseCase.self) { r in
            let repo = r.resolve(MindReaderRepositoryProtocol.self)!
            return RequestNextGameStepUseCase(repository: repo)
        }
        
        container.register(RequestQuizChoicesUseCase.self) { r in
            let repo = r.resolve(MindReaderRepositoryProtocol.self)!
            return RequestQuizChoicesUseCase(repository: repo)
        }
        
        container.register(VerifyHonestyUseCase.self) { r in
            let repo = r.resolve(MindReaderRepositoryProtocol.self)!
            return VerifyHonestyUseCase(repository: repo)
        }
        
        // MARK: - Coordinator
        
        container.register(MindReaderGameCoordinator.self) { r in
            MindReaderGameCoordinator(
                getCategoriesUseCase: r.resolve(GetCategoriesUseCase.self)!,
                requestNextGameStepUseCase: r.resolve(RequestNextGameStepUseCase.self)!,
                requestQuizChoicesUseCase: r.resolve(RequestQuizChoicesUseCase.self)!,
                verifyHonestyUseCase: r.resolve(VerifyHonestyUseCase.self)!
            )
        }.inObjectScope(.container)
        
        // MARK: - ViewModels
        
        container.register(MindReaderIntroViewModel.self) { r in
            MindReaderIntroViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!
            )
        }
        
        container.register(MindReaderGameViewModel.self) { r in
            MindReaderGameViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!,
                speechSynthesizer: r.resolve(SpeechSynthesizerProtocol.self)!
            )
        }
        
        container.register(MindReaderGuessViewModel.self) { r in
            MindReaderGuessViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!,
                speechSynthesizer: r.resolve(SpeechSynthesizerProtocol.self)!
            )
        }
        
        container.register(MindReaderTranslationViewModel.self) { r in
            MindReaderTranslationViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!
            )
        }
        
        container.register(MindReaderResultViewModel.self) { r in
            MindReaderResultViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!
            )
        }
        
        container.register(MindReaderFailureViewModel.self) { r in
            MindReaderFailureViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!
            )
        }
        
        container.register(MindReaderGiveUpViewModel.self) { r in
            MindReaderGiveUpViewModel(
                router: r.resolve(RouterProtocol.self)!,
                statsService: r.resolve(StatsService.self)!,
                coordinator: r.resolve(MindReaderGameCoordinator.self)!
            )
        }
    }
}
