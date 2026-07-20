//
//  AuthAssembly.swift
//  Lingua Quest
//
//  Created by Al3dwy on 14/07/2026.
//

import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return AuthRemoteDataSource(apiClient: apiClient)
        }

        container.register(AuthRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(AuthRemoteDataSourceProtocol.self)!
            let tokenStorage = resolver.resolve(SecureTokenStorageProtocol.self)!
            return AuthRepositoryImpl(remoteDataSource: remoteDataSource, tokenStorage: tokenStorage)
        }

        container.register(LoginUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(AuthRepositoryProtocol.self)!
            return LoginUseCase(repository: repository)
        }

        container.register(LoginViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            let userPreferences = resolver.resolve(UserPreferencesProtocol.self)!
            let loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)!
            return LoginViewModel(router: router, userPreferences: userPreferences, loginUseCase: loginUseCase)
        }

        container.register(SignUpViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return SignUpViewModel(router: router)
        }

        container.register(ForgetPasswordViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return ForgetPasswordViewModel(router: router)
        }

        container.register(VerifyEmailViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return VerifyEmailViewModel(router: router)
        }

        container.register(ResetPasswordViewModel.self) { resolver in
            let router = resolver.resolve(RouterProtocol.self)!
            return ResetPasswordViewModel(router: router)
        }
    }
}
