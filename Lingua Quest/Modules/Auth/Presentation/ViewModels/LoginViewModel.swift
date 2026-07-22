//
//  LoginViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Observation
import Foundation

@Observable
@MainActor
final class LoginViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private var userPreferences: UserPreferencesProtocol
    private let loginUseCase: LoginUseCaseProtocol
    private let oauthSignInHandler: OAuthSignInHandlerProtocol

    // MARK: - State
    var email: String = ""
    var password: String = ""
    var isPasswordVisible: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init
    init(
        router: RouterProtocol,
        userPreferences: UserPreferencesProtocol,
        loginUseCase: LoginUseCaseProtocol,
        oauthSignInHandler: OAuthSignInHandlerProtocol
    ) {
        self.router = router
        self.userPreferences = userPreferences
        self.loginUseCase = loginUseCase
        self.oauthSignInHandler = oauthSignInHandler
    }


    // MARK: - Intentions
    func login() {
        errorMessage = nil
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = L10n.Auth.Error.emailAndPasswordRequired
            return
        }
        
        isLoading = true

        Task {
            let result = await loginUseCase.execute(email: email, password: password)
            isLoading = false

            switch result {
            case .success(let data):
                userPreferences.isLoggedIn = true
                let user = data.user
                if user.nativeLanguage == nil || user.targetLanguages.isEmpty {
                    userPreferences.needsProfileCompletion = true
                }

            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func forgotPassword() {
        router.push(.forgetPassword)
    }

    func navigateToSignUp() {
        if userPreferences.spokenLanguageCode == nil || userPreferences.learningLanguageCode == nil {
            router.push(.completeProfile)
        } else {
            router.push(.signUp)
        }
    }

    func continueWithGoogle() {
        Task { await handleOAuth(.google) }
    }

    func continueWithApple() {
        Task { await handleOAuth(.apple) }
    }
    
    // MARK: - OAuth Shared Flow
    private func handleOAuth(_ provider: OAuthProviderType) async {
        errorMessage = nil
        isLoading = true

        let result = await oauthSignInHandler.handleSignIn(provider: provider)
        isLoading = false

        switch result {
        case .success:
            // State is already updated in handler (isLoggedIn = true, needsProfileCompletion set if needed)
            break
        case .failure(let message):
            errorMessage = message
        }
    }
}



// MARK: - Preview Helper
extension LoginViewModel {
    @MainActor
    static var preview: LoginViewModel {
        class MockRouter: RouterProtocol {
            func push(_ route: AppRoute) {}
            func pushAndReplace(_ route: AppRoute) {}
            func pushAndRemoveAll(_ route: AppRoute) {}
            func pop() {}
            func popToRoot() {}
            func present(_ sheet: AppSheet) {}
            func dismissSheet() {}
        }
        
        class MockUserPreferences: UserPreferencesProtocol {
            var isOnboardingCompleted: Bool = true
            var isLoggedIn: Bool = false
            var needsProfileCompletion: Bool = false
            var spokenLanguageCode: String? = "ar"
            var learningLanguageCode: String? = "en"
            var userLevel: String? = "beginner"
            var isDarkMode: Bool = false
            var appLanguage: String = "en"
        }
        
        class MockLoginUseCase: LoginUseCaseProtocol {
            func execute(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError> {
                return .failure(.invalidCredentials)
            }
        }
        class MockOAuthSignInHandler: OAuthSignInHandlerProtocol {
            func handleSignIn(provider: OAuthProviderType) async -> OAuthSignInResult {
                return .failure(message: "Mock failure")
            }
        }
        
        return LoginViewModel(
            router: MockRouter(),
            userPreferences: MockUserPreferences(),
            loginUseCase: MockLoginUseCase(),
            oauthSignInHandler: MockOAuthSignInHandler()
        )
    }
}
