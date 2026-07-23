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
            return ProfileRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryProtocol.self)!
            return GetProfileUseCase(repository: repository)
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
    }
}

