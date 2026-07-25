//
//  ResetPasswordViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ResetPasswordViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let resetPasswordUseCase: ResetPasswordUseCaseProtocol

    // MARK: - State
    let resetToken: String
    var newPassword: String = ""
    var confirmNewPassword: String = ""
    var isNewPasswordVisible: Bool = false
    var isConfirmNewPasswordVisible: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init
    init(resetToken: String, router: RouterProtocol, resetPasswordUseCase: ResetPasswordUseCaseProtocol) {
        self.resetToken = resetToken
        self.router = router
        self.resetPasswordUseCase = resetPasswordUseCase
    }

    // MARK: - Computed
    /// Simple client-side strength heuristic for the progress bar only.
    /// Not a replacement for backend validation (min 8 chars, letter + digit).
    var passwordStrengthProgress: Double {
        guard !newPassword.isEmpty else { return 0 }
        var score = 0.0
        if newPassword.count >= 8 { score += 0.34 }
        if newPassword.rangeOfCharacter(from: .decimalDigits) != nil { score += 0.33 }
        if newPassword.rangeOfCharacter(from: .letters) != nil { score += 0.33 }
        return min(score, 1.0)
    }

    // MARK: - Intentions
    func resetPassword() {
        errorMessage = nil

        guard newPassword == confirmNewPassword else {
            errorMessage = L10n.Auth.Error.passwordsDoNotMatch
            return
        }

        guard passwordStrengthProgress >= 1.0 else {
            errorMessage = L10n.Auth.Error.weakPassword
            return
        }

        isLoading = true

        Task {
            let result = await resetPasswordUseCase.execute(resetToken: resetToken, newPassword: newPassword)
            isLoading = false

            switch result {
            case .success:
                router.popToRoot()
            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func navigateToLogin() {
        router.popToRoot()
    }
}

// MARK: - Preview Helper
extension ResetPasswordViewModel {
    @MainActor
    static var preview: ResetPasswordViewModel {
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

        class MockResetPasswordUseCase: ResetPasswordUseCaseProtocol {
            func execute(resetToken: String, newPassword: String) async -> Result<Void, AuthError> {
                .success(())
            }
        }

        return ResetPasswordViewModel(
            resetToken: "rst_preview_token",
            router: MockRouter(),
            resetPasswordUseCase: MockResetPasswordUseCase()
        )
    }
}
