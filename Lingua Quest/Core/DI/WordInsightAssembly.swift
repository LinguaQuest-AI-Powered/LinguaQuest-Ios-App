//
//  WordInsightAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Swinject

final class WordInsightAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SpeechSynthesizerProtocol.self) { _ in
            AVSpeechSynthesizerService()
        }.inObjectScope(.container)
        
        container.register(WordInsightRemoteDataSourceProtocol.self) { _ in
            WordInsightRemoteDataSource()
        }
        
        container.register(WordInsightRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(WordInsightRemoteDataSourceProtocol.self)!
            return WordInsightRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetWordInsightUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(WordInsightRepositoryProtocol.self)!
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
