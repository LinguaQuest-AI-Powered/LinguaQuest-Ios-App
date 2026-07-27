//
//  SpeakingLabAssembly.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import Swinject

@MainActor
final class SpeakingLabAssembly: Assembly {
    func assemble(container: Container) {
        
        // Data Sources
        container.register(VoiceEvaluationRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return VoiceEvaluationRemoteDataSource(apiClient: apiClient)
        }.inObjectScope(.container)
        
        container.register(VoiceProgressRemoteDataSourceProtocol.self) { _ in
            return VoiceProgressRemoteDataSource()
        }.inObjectScope(.container)
        
        container.register(VoiceSentenceGeneratorDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return VoiceSentenceGeneratorDataSource(apiClient: apiClient)
        }.inObjectScope(.container)
        
        container.register(SpeechRecognitionServiceProtocol.self) { _ in
            return SpeechRecognitionService()
        }.inObjectScope(.container)
        
        // Repository
        container.register(VoiceEvaluationRepositoryProtocol.self) { resolver in
            let evalDataSource = resolver.resolve(VoiceEvaluationRemoteDataSourceProtocol.self)!
            let progDataSource = resolver.resolve(VoiceProgressRemoteDataSourceProtocol.self)!
            let genDataSource = resolver.resolve(VoiceSentenceGeneratorDataSourceProtocol.self)!
            let speechService = resolver.resolve(SpeechRecognitionServiceProtocol.self)!
            return VoiceEvaluationRepositoryImpl(
                evaluationDataSource: evalDataSource,
                progressDataSource: progDataSource,
                generatorDataSource: genDataSource,
                speechRecognitionService: speechService
            )
        }.inObjectScope(.container)
        
        // Use Cases
        container.register(GetDailyVoiceSentencesUseCase.self) { resolver in
            let repo = resolver.resolve(VoiceEvaluationRepositoryProtocol.self)!
            let prefs = resolver.resolve(UserPreferencesProtocol.self)!
            return GetDailyVoiceSentencesUseCase(repository: repo, userPreferences: prefs)
        }
        
        container.register(EvaluateVoiceUseCase.self) { resolver in
            let repo = resolver.resolve(VoiceEvaluationRepositoryProtocol.self)!
            let prefs = resolver.resolve(UserPreferencesProtocol.self)!
            return EvaluateVoiceUseCase(repository: repo, userPreferences: prefs)
        }
        
        container.register(SaveVoiceProgressUseCase.self) { resolver in
            let repo = resolver.resolve(VoiceEvaluationRepositoryProtocol.self)!
            let prefs = resolver.resolve(UserPreferencesProtocol.self)!
            return SaveVoiceProgressUseCase(repository: repo, userPreferences: prefs)
        }
        
        container.register(GetVoiceProgressUseCase.self) { resolver in
            let repo = resolver.resolve(VoiceEvaluationRepositoryProtocol.self)!
            let prefs = resolver.resolve(UserPreferencesProtocol.self)!
            return GetVoiceProgressUseCase(repository: repo, userPreferences: prefs)
        }
        
        // Services
        container.register(AudioRecorderServiceProtocol.self) { _ in
            return AudioRecorderService()
        }.inObjectScope(.transient)
        
        // ViewModels
        container.register(VoiceGameViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getSentencesUseCase = resolver.resolve(GetDailyVoiceSentencesUseCase.self)!
            let evaluateUseCase = resolver.resolve(EvaluateVoiceUseCase.self)!
            let audioService = resolver.resolve(AudioRecorderServiceProtocol.self)!
            let speechService = resolver.resolve(SpeechSynthesizerProtocol.self)!
            
            return VoiceGameViewModel(
                router: router,
                getSentencesUseCase: getSentencesUseCase,
                evaluateUseCase: evaluateUseCase,
                audioService: audioService,
                speechService: speechService
            )
        }
        
        container.register(VoiceGameResultViewModel.self) { (resolver, args: (Data, VoiceSentence)) in
            let router = resolver.resolve(RouterProtocol.self)!
            let evaluateUseCase = resolver.resolve(EvaluateVoiceUseCase.self)!
            let saveProgressUseCase = resolver.resolve(SaveVoiceProgressUseCase.self)!
            return VoiceGameResultViewModel(
                router: router,
                evaluateUseCase: evaluateUseCase,
                saveProgressUseCase: saveProgressUseCase,
                audioData: args.0,
                sentence: args.1
            )
        }
    }
}
