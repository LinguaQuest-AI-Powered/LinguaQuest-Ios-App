//
//  VerifyPasswordResetOtpViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class VerifyPasswordResetOtpViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let sendOtpUseCase: SendOtpUseCaseProtocol
    private let verifyPasswordResetOtpUseCase: VerifyPasswordResetOtpUseCaseProtocol

    // MARK: - State
    let email: String
    var otpCode: String = "" {
        didSet {
            let digitsOnly = otpCode.filter(\.isNumber)
            let clamped = String(digitsOnly.prefix(otpLength))
            if clamped != otpCode {
                otpCode = clamped
            }
        }
    }
    var timeRemaining: Int = 60
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private var countdownTask: Task<Void, Never>?
    private let otpLength = 4

    // MARK: - Init
    init(
        email: String,
        router: RouterProtocol,
        sendOtpUseCase: SendOtpUseCaseProtocol,
        verifyPasswordResetOtpUseCase: VerifyPasswordResetOtpUseCaseProtocol
    ) {
        self.email = email
        self.router = router
        self.sendOtpUseCase = sendOtpUseCase
        self.verifyPasswordResetOtpUseCase = verifyPasswordResetOtpUseCase
        startCountdown()
    }

    func onDisappear() {
        countdownTask?.cancel()
    }

    // MARK: - Intentions
    func verifyCode() {
        errorMessage = nil

        guard otpCode.count == otpLength else {
            errorMessage = L10n.Auth.Error.invalidOtpLength
            return
        }

        isLoading = true

        Task {
            let result = await verifyPasswordResetOtpUseCase.execute(email: email, otp: otpCode)
            isLoading = false

            switch result {
            case .success(let (resetToken, _)):
                router.push(.resetPassword(resetToken: resetToken))
            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func resendCode() {
        guard timeRemaining == 0 else { return }
        errorMessage = nil

        Task {
            let result = await sendOtpUseCase.execute(email: email, purpose: .passwordReset)
            switch result {
            case .success:
                startCountdown()
            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func navigateBack() {
        countdownTask?.cancel()
        router.pop()
    }

    // MARK: - Countdown
    private func startCountdown() {
        countdownTask?.cancel()
        timeRemaining = 60

        countdownTask = Task { [weak self] in
            guard let self else { return }
            while self.timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                self.timeRemaining -= 1
            }
        }
    }
}

// MARK: - Preview Helper
extension VerifyPasswordResetOtpViewModel {
    @MainActor
    static var preview: VerifyPasswordResetOtpViewModel {
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

        class MockSendOtpUseCase: SendOtpUseCaseProtocol {
            func execute(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> { .success(()) }
        }

        class MockVerifyUseCase: VerifyPasswordResetOtpUseCaseProtocol {
            func execute(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError> {
                .success((resetToken: "rst_preview_token", expiresIn: 900))
            }
        }

        return VerifyPasswordResetOtpViewModel(
            email: "preview@example.com",
            router: MockRouter(),
            sendOtpUseCase: MockSendOtpUseCase(),
            verifyPasswordResetOtpUseCase: MockVerifyUseCase()
        )
    }
}
