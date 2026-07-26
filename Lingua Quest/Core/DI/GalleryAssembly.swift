//
//  GalleryAssembly.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Swinject

final class GalleryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(WordInsightRemoteDataSourceProtocol.self) { _ in
            WordInsightRemoteDataSource()
        }
        
        container.register(GalleryRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(WordInsightRemoteDataSourceProtocol.self)!
            return GalleryRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetCapturedItemsUseCase.self) { r in
            GetCapturedItemsUseCase(repository: r.resolve(GalleryRepositoryProtocol.self)!)
        }
        
        container.register(SaveCapturedItemUseCase.self) { r in
            SaveCapturedItemUseCase(repository: r.resolve(GalleryRepositoryProtocol.self)!)
        }
        
        container.register(GalleryViewModel.self) { r in
            GalleryViewModel(
                getCapturedItemsUseCase: r.resolve(GetCapturedItemsUseCase.self)!,
                saveCapturedItemUseCase: r.resolve(SaveCapturedItemUseCase.self)!,
                getSavedVocabularyWordsUseCase: r.resolve(GetSavedVocabularyWordsUseCaseProtocol.self),
                speechSynthesizer: r.resolve(SpeechSynthesizerProtocol.self),
                router: r.resolve(RouterProtocol.self)!,
                userPreferences: r.resolve(UserPreferencesProtocol.self)!
            )
        }.inObjectScope(.container)
        
        // MARK: - Word Insight
        container.register(SpeechSynthesizerProtocol.self) { _ in
            AVSpeechSynthesizerService()
        }.inObjectScope(.container)
        
        container.register(GetWordInsightUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(GalleryRepositoryProtocol.self)!
            return GetWordInsightUseCase(repository: repository)
        }
        
        container.register(WordInsightViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let useCase = resolver.resolve(GetWordInsightUseCaseProtocol.self)!
            let speech = resolver.resolve(SpeechSynthesizerProtocol.self)!
            return WordInsightViewModel(router: router, getWordInsightUseCase: useCase, speechSynthesizer: speech)
        }
    }
}
