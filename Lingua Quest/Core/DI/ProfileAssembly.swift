//
//  ProfileAssembly.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Swinject

final class ProfileAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(ProfileRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return ProfileRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(ProfileRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(ProfileRemoteDataSourceProtocol.self)!
            let tokenStorage = resolver.resolve(SecureTokenStorageProtocol.self)!
            return ProfileRepositoryImpl(remoteDataSource: remoteDataSource, tokenStorage: tokenStorage)
        }
        
        container.register(GetProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return GetProfileUseCase(repository: repository)
        }
        
        container.register(CompleteProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return CompleteProfileUseCase(repository: repository)
        }
        
        container.register(UploadProfilePhotoUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return UploadProfilePhotoUseCase(repository: repository)
        }
        
        container.register(UpdateProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return UpdateProfileUseCase(repository: repository)
        }
        
        container.register(EditProfileViewModel.self) { resolver in
            let getProfileUseCase = resolver.resolve(GetProfileUseCaseProtocol.self)!
            let updateProfileUseCase = resolver.resolve(UpdateProfileUseCaseProtocol.self)!
            let uploadProfilePhotoUseCase = resolver.resolve(UploadProfilePhotoUseCaseProtocol.self)!
            return EditProfileViewModel(
                getProfileUseCase: getProfileUseCase,
                updateProfileUseCase: updateProfileUseCase,
                uploadProfilePhotoUseCase: uploadProfilePhotoUseCase
            )
        }
        
        container.register(ProfileViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getProfileUseCase = resolver.resolve(GetProfileUseCaseProtocol.self)!
            let uploadProfilePhotoUseCase = resolver.resolve(UploadProfilePhotoUseCaseProtocol.self)!
            return ProfileViewModel(
                router: router,
                getProfileUseCase: getProfileUseCase,
                uploadProfilePhotoUseCase: uploadProfilePhotoUseCase
            )
        }
        
        // MARK: - Achievements
        container.register(GetAchievementsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return GetAchievementsUseCase(repository: repository)
        }
        
        container.register(GetWeeklyRewardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return GetWeeklyRewardUseCase(repository: repository)
        }
        
        container.register(ClaimWeeklyRewardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return ClaimWeeklyRewardUseCase(repository: repository)
        }
        
        container.register(AchievementsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let getAchievementsUseCase = resolver.resolve(GetAchievementsUseCaseProtocol.self)!
            let getWeeklyRewardUseCase = resolver.resolve(GetWeeklyRewardUseCaseProtocol.self)!
            let claimWeeklyRewardUseCase = resolver.resolve(ClaimWeeklyRewardUseCaseProtocol.self)!
            
            return AchievementsViewModel(
                router: router,
                getAchievementsUseCase: getAchievementsUseCase,
                getWeeklyRewardUseCase: getWeeklyRewardUseCase,
                claimWeeklyRewardUseCase: claimWeeklyRewardUseCase
            )
        }
        
        // MARK: - Leaderboard
        container.register(GetLeaderboardUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return GetLeaderboardUseCase(repository: repository)
        }
        
        container.register(LeaderboardViewModel.self) { (resolver, languageId: Int) in
            let router = resolver.resolve(RouterProtocol.self)!
            let getLeaderboardUseCase = resolver.resolve(GetLeaderboardUseCaseProtocol.self)!
            return LeaderboardViewModel(router: router, getLeaderboardUseCase: getLeaderboardUseCase, languageId: languageId)
        }
        
        // MARK: - Settings
        container.register(SettingsViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let sessionManager = resolver.resolve(SessionManagerProtocol.self)!
            return SettingsViewModel(router: router, sessionManager: sessionManager)
        }
    }
}

