//
//  LockScreenVocabularyAssembly.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import Swinject

final class LockScreenVocabularyAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Data Layer
        container.register(VocabularyRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return VocabularyRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(VocabularyRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(VocabularyRemoteDataSourceProtocol.self)!
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            return VocabularyRepositoryImpl(remoteDataSource: remoteDataSource, userPreferences: userPreferences)
        }.inObjectScope(.container)
        
        // MARK: - Domain Layer
        container.register(GenerateVocabularyWordsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(VocabularyRepositoryProtocol.self)!
            return GenerateVocabularyWordsUseCase(repository: repository)
        }
        
        container.register(GetSavedVocabularyWordsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(VocabularyRepositoryProtocol.self)!
            let prefs = resolver.resolve(UserPreferencesProtocol.self)!
            return GetSavedVocabularyWordsUseCase(repository: repository, userPreferences: prefs)
        }
        
        container.register(MarkVocabularyWordAsShownUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(VocabularyRepositoryProtocol.self)!
            return MarkVocabularyWordAsShownUseCase(repository: repository)
        }
        
        container.register(MarkWordAsAddedToJournalUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(VocabularyRepositoryProtocol.self)!
            return MarkWordAsAddedToJournalUseCase(repository: repository)
        }
        
        container.register(ActivateLockScreenVocabularyUseCaseProtocol.self) { resolver in
            let generateWords = resolver.resolve(GenerateVocabularyWordsUseCaseProtocol.self)!
            let getSavedWords = resolver.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)!
            let scheduleNotification = resolver.resolve(ScheduleVocabularyNotificationUseCaseProtocol.self)!
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            return ActivateLockScreenVocabularyUseCase(
                generateVocabularyWordsUseCase: generateWords,
                getSavedVocabularyWordsUseCase: getSavedWords,
                scheduleVocabularyNotificationUseCase: scheduleNotification,
                userPreferences: userPreferences
            )
        }
        
        container.register(ScheduleVocabularyNotificationUseCaseProtocol.self) { _ in
            return ScheduleVocabularyNotificationUseCase()
        }
        
        // MARK: - Presentation Layer (ViewModels)
        // We will add VocabularyWordDetailViewModel here in Phase 5
    }
}
