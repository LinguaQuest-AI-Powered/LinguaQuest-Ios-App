

import Swinject

final class HomeAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(HomeLocalDataSourceProtocol.self) { _ in
            return HomeLocalDataSource()
        }.inObjectScope(.container)
        
        container.register(HomeRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return HomeRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(HomeRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(HomeRemoteDataSourceProtocol.self)!
            let localDataSource = resolver.resolve(HomeLocalDataSourceProtocol.self)!
            return HomeRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        }
        
        container.register(GetHomeDataUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetHomeDataUseCase(repository: repository)
        }
        
        container.register(GetHomeWorldsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetHomeWorldsUseCase(repository: repository)
        }
        
        container.register(GetDailyRewardUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetDailyRewardUseCase(repository: repository)
        }
        
        container.register(ClaimDailyRewardUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return ClaimDailyRewardUseCase(repository: repository)
        }
        
        container.register(DailyRewardViewModel.self) { resolver in
            let getDailyRewardUseCase = resolver.resolve(GetDailyRewardUseCase.self)!
            let claimDailyRewardUseCase = resolver.resolve(ClaimDailyRewardUseCase.self)!
            let statsService = resolver.resolve(StatsService.self)!
            let soundPlayer = resolver.resolve(AppSoundPlayer.self)!
            return DailyRewardViewModel(getDailyRewardUseCase: getDailyRewardUseCase, claimDailyRewardUseCase: claimDailyRewardUseCase, statsService: statsService, soundPlayer: soundPlayer)
        }
        
        container.register(GetMyLanguagesUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetMyLanguagesUseCase(repository: repository)
        }
        
        container.register(GetAvailableLanguagesUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return GetAvailableLanguagesUseCase(repository: repository)
        }
        
        container.register(SwitchActiveLanguageUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return SwitchActiveLanguageUseCase(repository: repository)
        }
        
        container.register(AddLanguagesUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return AddLanguagesUseCase(repository: repository)
        }
        
        container.register(ChangeNativeLanguageUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return ChangeNativeLanguageUseCase(repository: repository)
        }
        
        container.register(RemoveLanguagesUseCase.self) { resolver in
            let repository = resolver.resolve(HomeRepositoryProtocol.self)!
            return RemoveLanguagesUseCase(repository: repository)
        }
        
        container.register(LanguageViewModel.self) { resolver in
            let getMy = resolver.resolve(GetMyLanguagesUseCase.self)!
            let getAvailable = resolver.resolve(GetAvailableLanguagesUseCase.self)!
            let switchActive = resolver.resolve(SwitchActiveLanguageUseCase.self)!
            let addLangs = resolver.resolve(AddLanguagesUseCase.self)!
            let removeLangs = resolver.resolve(RemoveLanguagesUseCase.self)!
            let userPreferences = resolver.resolve(UserPreferences.self)!
            let activateLockScreenVocabularyUseCase = resolver.resolve(ActivateLockScreenVocabularyUseCaseProtocol.self)!
            return LanguageViewModel(
                getMyLanguagesUseCase: getMy,
                getAvailableLanguagesUseCase: getAvailable,
                switchActiveLanguageUseCase: switchActive,
                addLanguagesUseCase: addLangs,
                removeLanguagesUseCase: removeLangs,
                activateLockScreenVocabularyUseCase: activateLockScreenVocabularyUseCase,
                userPreferences: userPreferences
            )
        }.inObjectScope(.container)
        
        container.register(HomeViewModel.self) { resolver in
            let getHomeDataUseCase = resolver.resolve(GetHomeDataUseCaseProtocol.self)!
            let getHomeWorldsUseCase = resolver.resolve(GetHomeWorldsUseCaseProtocol.self)!
            let getContinueLevelUseCase = resolver.resolve(GetContinueLevelUseCaseProtocol.self)!
            let startLevelUseCase = resolver.resolve(StartLevelUseCase.self)!
            let dailyRewardViewModel = resolver.resolve(DailyRewardViewModel.self)!
            let languageViewModel = resolver.resolve(LanguageViewModel.self)!
            let dailyMissionCardViewModel = resolver.resolve(DailyMissionCardViewModel.self)!
            let statsService = resolver.resolve(StatsService.self)!
            let router = resolver.resolve(RouterProtocol.self)!
            return HomeViewModel(
                getHomeDataUseCase: getHomeDataUseCase,
                getHomeWorldsUseCase: getHomeWorldsUseCase,
                getContinueLevelUseCase: getContinueLevelUseCase,
                startLevelUseCase: startLevelUseCase,
                dailyRewardViewModel: dailyRewardViewModel,
                languageViewModel: languageViewModel,
                dailyMissionCardViewModel: dailyMissionCardViewModel,
                statsService: statsService,
                router: router
            )
        }
        
        container.register(AllWorldsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getHomeWorldsUseCase = resolver.resolve(GetHomeWorldsUseCaseProtocol.self)!
            let languageViewModel = resolver.resolve(LanguageViewModel.self)!
            return AllWorldsViewModel(router: router, getHomeWorldsUseCase: getHomeWorldsUseCase, languageViewModel: languageViewModel)
        }
    }
}
