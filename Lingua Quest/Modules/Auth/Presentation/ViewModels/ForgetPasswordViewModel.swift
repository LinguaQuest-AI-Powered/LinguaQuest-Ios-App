//
//  ForgetPasswordViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ForgetPasswordViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let sendOtpUseCase: SendOtpUseCaseProtocol

    // MARK: - State
    var email: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init
    init(router: RouterProtocol, sendOtpUseCase: SendOtpUseCaseProtocol) {
        self.router = router
        self.sendOtpUseCase = sendOtpUseCase
    }

    // MARK: - Intentions
    func sendResetLink() {
        errorMessage = nil

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = L10n.Auth.Error.emailRequired
            return
        }

        isLoading = true

        Task {
            let result = await sendOtpUseCase.execute(email: email, purpose: .passwordReset)
            isLoading = false

            switch result {
            case .success:
                router.push(.verifyPasswordResetOtp(email: email))
            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func navigateToLogin() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension ForgetPasswordViewModel {
    @MainActor
    static var preview: ForgetPasswordViewModel {
        class MockRouter: RouterProtocol {
            func push(_ route: AppRoute) {}
            func pushAndReplace(_ route: AppRoute) {}
            func pushAndRemoveAll(_ route: AppRoute) {}
            func pop() {}
            func popToRoot() {}
            func present(_ sheet: AppSheet) {}
            func dismissSheet() {}
        }

        class MockSendOtpUseCase: SendOtpUseCaseProtocol {
            func execute(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> {
                return .success(())
            }
        }

        return ForgetPasswordViewModel(router: MockRouter(), sendOtpUseCase: MockSendOtpUseCase())
    }
}
