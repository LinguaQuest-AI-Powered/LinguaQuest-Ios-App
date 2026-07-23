//
//  AuthAssembly.swift
//  Lingua Quest
//
//  Created by Al3dwy on 14/07/2026.
//

import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Services (OAuth)
        container.register(GoogleSignInServiceProtocol.self) { _ in
            GoogleSignInService()
        }

        container.register(AppleSignInServiceProtocol.self) { _ in
            AppleSignInService()
        }

        // MARK: - Data Sources & Providers
        container.register(AuthRemoteDataSourceProtocol.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return AuthRemoteDataSource(apiClient: apiClient)
        }
        
        container.register(AuthTokenProviding.self) { resolver in
            let tokenStorage = resolver.resolve(SecureTokenStorageProtocol.self)!
            let remoteDataSource = resolver.resolve(AuthRemoteDataSourceProtocol.self)!
            return AuthTokenProvider(tokenStorage: tokenStorage, remoteDataSource: remoteDataSource)
        }.inObjectScope(.container)

        // MARK: - Repositories
        container.register(AuthRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(AuthRemoteDataSourceProtocol.self)!
            let tokenStorage = resolver.resolve(SecureTokenStorageProtocol.self)!
            return AuthRepositoryImpl(remoteDataSource: remoteDataSource, tokenStorage: tokenStorage)
        }

        // MARK: - Use Cases
        container.register(LoginUseCaseProtocol.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        container.register(RegisterUseCaseProtocol.self) { resolver in
            RegisterUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        container.register(SendOtpUseCaseProtocol.self) { resolver in
            SendOtpUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        container.register(VerifySignupOtpUseCaseProtocol.self) { resolver in
            VerifySignupOtpUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        container.register(VerifyPasswordResetOtpUseCaseProtocol.self) { resolver in
            VerifyPasswordResetOtpUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        container.register(ResetPasswordUseCaseProtocol.self) { resolver in
            ResetPasswordUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(RefreshTokenUseCaseProtocol.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(LogoutUseCaseProtocol.self) { resolver in
            LogoutUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(FirebaseLoginUseCaseProtocol.self) { resolver in
            FirebaseLoginUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }

        // MARK: - Handlers
        container.register(OAuthSignInHandlerProtocol.self) { resolver in
            OAuthSignInHandler(
                googleSignInService: resolver.resolve(GoogleSignInServiceProtocol.self)!,
                appleSignInService: resolver.resolve(AppleSignInServiceProtocol.self)!,
                firebaseLoginUseCase: resolver.resolve(FirebaseLoginUseCaseProtocol.self)!,
                userPreferences: resolver.resolve(UserPreferencesProtocol.self)!
            )
        }

        // MARK: - View Models
        container.register(ProfileCompletionViewModel.self) { resolver in
            ProfileCompletionViewModel(
                router: resolver.resolve(RouterProtocol.self)!,
                userPreferences: resolver.resolve(UserPreferencesProtocol.self)!,
                getAvailableLanguagesUseCase: resolver.resolve(GetAvailableLanguagesUseCase.self)!,
                completeProfileUseCase: resolver.resolve(CompleteProfileUseCaseProtocol.self)!
            )
        }

        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(
                router: resolver.resolve(RouterProtocol.self)!,
                userPreferences: resolver.resolve(UserPreferencesProtocol.self)!,
                loginUseCase: resolver.resolve(LoginUseCaseProtocol.self)!,
                getProfileUseCase: resolver.resolve(GetProfileUseCaseProtocol.self)!,
                oauthSignInHandler: resolver.resolve(OAuthSignInHandlerProtocol.self)!
            )
        }

        container.register(SignUpViewModel.self) { resolver in
            SignUpViewModel(
                router: resolver.resolve(RouterProtocol.self)!,
                userPreferences: resolver.resolve(UserPreferencesProtocol.self)!,
                registerUseCase: resolver.resolve(RegisterUseCaseProtocol.self)!,
                oauthSignInHandler: resolver.resolve(OAuthSignInHandlerProtocol.self)!
            )
        }

        container.register(VerifyEmailViewModel.self) { (resolver, email: String) in
            VerifyEmailViewModel(
                email: email,
                router: resolver.resolve(RouterProtocol.self)!,
                sendOtpUseCase: resolver.resolve(SendOtpUseCaseProtocol.self)!,
                verifySignupOtpUseCase: resolver.resolve(VerifySignupOtpUseCaseProtocol.self)!
            )
        }

        container.register(ForgetPasswordViewModel.self) { resolver in
            ForgetPasswordViewModel(
                router: resolver.resolve(RouterProtocol.self)!,
                sendOtpUseCase: resolver.resolve(SendOtpUseCaseProtocol.self)!
            )
        }

        container.register(VerifyPasswordResetOtpViewModel.self) { (resolver, email: String) in
            VerifyPasswordResetOtpViewModel(
                email: email,
                router: resolver.resolve(RouterProtocol.self)!,
                sendOtpUseCase: resolver.resolve(SendOtpUseCaseProtocol.self)!,
                verifyPasswordResetOtpUseCase: resolver.resolve(VerifyPasswordResetOtpUseCaseProtocol.self)!
            )
        }

        container.register(ResetPasswordViewModel.self) { (resolver, resetToken: String) in
            ResetPasswordViewModel(
                resetToken: resetToken,
                router: resolver.resolve(RouterProtocol.self)!,
                resetPasswordUseCase: resolver.resolve(ResetPasswordUseCaseProtocol.self)!
            )
        }
    }
}
