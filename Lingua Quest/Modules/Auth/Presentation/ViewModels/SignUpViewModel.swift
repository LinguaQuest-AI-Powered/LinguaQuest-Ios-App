//
//  SignUpViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class SignUpViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let userPreferences: UserPreferencesProtocol
    private let registerUseCase: RegisterUseCaseProtocol

    // MARK: - State
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordVisible: Bool = false
    var isConfirmPasswordVisible: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init
    init(router: RouterProtocol, userPreferences: UserPreferencesProtocol, registerUseCase: RegisterUseCaseProtocol) {
        self.router = router
        self.userPreferences = userPreferences
        self.registerUseCase = registerUseCase
    }

    // MARK: - Intentions
    func createAccount() {
        errorMessage = nil

        guard password == confirmPassword else {
            errorMessage = L10n.Auth.Error.passwordsDoNotMatch
            return
        }

        guard let nativeLanguage = backendLanguageName(for: userPreferences.spokenLanguageCode),
                let targetLanguage = backendLanguageName(for: userPreferences.learningLanguageCode) else {
            errorMessage = L10n.Auth.Error.missingOnboardingLanguages
            return
        }

        isLoading = true

        Task {
            let result = await registerUseCase.execute(
                email: email, username: username, password: password,
                nativeLanguage: nativeLanguage, targetLanguage: targetLanguage
            )
            isLoading = false

            switch result {
            case .success(let account):
                router.push(.verifyEmail(email: account.email))

            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func navigateToLogin() {
        router.push(.login)
    }

    func continueWithGoogle() {
        // Wired up once Firebase OAuth flow is implemented
    }

    func continueWithApple() {
        // Wired up once Firebase OAuth flow is implemented
    }

    // MARK: - Helpers
    /// Converts stored language code (e.g., "es") to the English display name (e.g., "Spanish")
    /// expected by the Backend, regardless of the user's device language.
    private func backendLanguageName(for code: String?) -> String? {
        guard let code else { return nil }
        // Force English locale so the backend always gets standard English names
        let englishLocale = Locale(identifier: "en_US")
        return englishLocale.localizedString(forLanguageCode: code)?.capitalized
    }
}


// MARK: - Preview Helper
extension SignUpViewModel {
    @MainActor
    static var preview: SignUpViewModel {
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
            var spokenLanguageCode: String? = "ar"
            var learningLanguageCode: String? = "en"
            var userLevel: String? = "beginner"
            var isLoggedIn: Bool = false
        }
        
        class MockRegisterUseCase: RegisterUseCaseProtocol {
            func execute(email: String, username: String, password: String, nativeLanguage: String, targetLanguage: String) async -> Result<RegisteredAccountEntity, AuthError> {
                return .failure(.invalidCredentials)
            }
        }
        
        return SignUpViewModel(
            router: MockRouter(),
            userPreferences: MockUserPreferences(),
            registerUseCase: MockRegisterUseCase()
        )
    }
}
