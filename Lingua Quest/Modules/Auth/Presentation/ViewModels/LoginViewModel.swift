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
    private var userPreferences: UserPreferences
    private let loginUseCase: LoginUseCaseProtocol
    private let getProfileUseCase: GetProfileUseCaseProtocol
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
        userPreferences: UserPreferences,
        loginUseCase: LoginUseCaseProtocol,
        getProfileUseCase: GetProfileUseCaseProtocol,
        oauthSignInHandler: OAuthSignInHandlerProtocol
    ) {
        self.router = router
        self.userPreferences = userPreferences
        self.loginUseCase = loginUseCase
        self.getProfileUseCase = getProfileUseCase
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

            switch result {
            case .success(let data):
                userPreferences.isLoggedIn = true
                userPreferences.userId = data.user.id
                userPreferences.email = email
                
                // Set appLanguage based on backend nativeLanguage if available
                if let nativeLangCode = data.user.nativeLanguage {
                    if let mapped = AppLanguage.allCases.first(where: { $0.code.lowercased() == nativeLangCode.lowercased() || $0.name.lowercased() == nativeLangCode.lowercased() }) {
                        UserDefaults.standard.set(mapped.code, forKey: AppConstants.UserDefaultsKeys.appLanguage)
                    }
                }
                
                do {
                    let profile = try await getProfileUseCase.execute()
                    userPreferences.needsProfileCompletion = profile.currentLanguageCode.isEmpty
                    if !profile.currentLanguageCode.isEmpty {
                        userPreferences.learningLanguageCode = profile.currentLanguageCode
                        userPreferences.targetLanguageName = profile.currentLanguageName
                    }
                } catch {
                    // Fallback
                    let user = data.user
                    userPreferences.needsProfileCompletion = user.nativeLanguage == nil || user.targetLanguages.isEmpty
                }
                isLoading = false

            case .failure(let error):
                errorMessage = error.errorDescription
                isLoading = false
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
            func pop(count: Int) {}
            func popToRoot() {}
            func present(_ sheet: AppSheet) {}
            func dismissSheet() {}
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
        
        class MockGetProfileUseCase: GetProfileUseCaseProtocol {
            func execute() async throws -> UserProfileEntity {
                throw AuthError.unknown("Mock Error")
            }
        }
        
        return LoginViewModel(
            router: MockRouter(),
            userPreferences: UserPreferences(),
            loginUseCase: MockLoginUseCase(),
            getProfileUseCase: MockGetProfileUseCase(),
            oauthSignInHandler: MockOAuthSignInHandler()
        )
    }
}
