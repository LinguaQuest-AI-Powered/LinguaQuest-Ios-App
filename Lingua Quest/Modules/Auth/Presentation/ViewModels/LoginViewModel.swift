//
//  LoginViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Observation

@Observable
@MainActor
final class LoginViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private var userPreferences: UserPreferencesProtocol
    private let loginUseCase: LoginUseCaseProtocol

    // MARK: - State
    var email: String = ""
    var password: String = ""
    var isPasswordVisible: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init
    init(router: RouterProtocol, userPreferences: UserPreferencesProtocol, loginUseCase: LoginUseCaseProtocol) {
        self.router = router
        self.userPreferences = userPreferences
        self.loginUseCase = loginUseCase
    }

    // MARK: - Intentions
    func login() {
        errorMessage = nil
        isLoading = true

        Task {
            let result = await loginUseCase.execute(email: email, password: password)
            isLoading = false

            switch result {
            case .success:
                userPreferences.isLoggedIn = true
                router.push(.home)

            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func forgotPassword() {
        router.push(.forgetPassword)
    }

    func navigateToSignUp() {
        router.push(.signUp)
    }

    func continueWithGoogle() {
        // Wired up once Firebase OAuth flow is implemented (loginWithFirebase use case)
    }

    func continueWithApple() {
        // Wired up once Firebase OAuth flow is implemented (loginWithFirebase use case)
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
            var spokenLanguageCode: String? = "ar"
            var learningLanguageCode: String? = "en"
            var userLevel: String? = "beginner"
            var isLoggedIn: Bool = false
        }
        
        class MockLoginUseCase: LoginUseCaseProtocol {
            func execute(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError> {
                return .failure(.invalidCredentials)
            }
        }
        
        return LoginViewModel(
            router: MockRouter(),
            userPreferences: MockUserPreferences(),
            loginUseCase: MockLoginUseCase()
        )
    }
}
