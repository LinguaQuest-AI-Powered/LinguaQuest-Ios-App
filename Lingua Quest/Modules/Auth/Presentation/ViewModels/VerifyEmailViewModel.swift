//
//  VerifyEmailViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class VerifyEmailViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let sendOtpUseCase: SendOtpUseCaseProtocol
    private let verifySignupOtpUseCase: VerifySignupOtpUseCaseProtocol

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
    
    // Toast State
    var showToast: Bool = false
    var toastType: AppToastType = .success
    var toastTitle: String = ""
    var toastSubtitle: String? = nil

    private var countdownTask: Task<Void, Never>?
    private let otpLength = 4

    // MARK: - Init
    init(email: String, router: RouterProtocol, sendOtpUseCase: SendOtpUseCaseProtocol, verifySignupOtpUseCase: VerifySignupOtpUseCaseProtocol) {
        self.email = email
        self.router = router
        self.sendOtpUseCase = sendOtpUseCase
        self.verifySignupOtpUseCase = verifySignupOtpUseCase
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
            let result = await verifySignupOtpUseCase.execute(email: email, otp: otpCode)
            isLoading = false

            switch result {
            case .success:
                router.push(.login)
            case .failure(let error):
                errorMessage = error.errorDescription
            }
        }
    }

    func resendCode() {
        guard timeRemaining == 0 else { return }
        errorMessage = nil
        otpCode = ""
        isLoading = true

        Task {
            let result = await sendOtpUseCase.execute(email: email, purpose: .signup)
            isLoading = false
            switch result {
            case .success:
                startCountdown()
                toastType = .success
                toastTitle = L10n.Auth.otpSentTitle
                toastSubtitle = L10n.Auth.otpSentDesc
                showToast = true
            case .failure(let error):
                toastType = .error
                toastTitle = L10n.Common.error
                toastSubtitle = error.errorDescription
                showToast = true
            }
        }
    }

    func navigateToLogin() {
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
extension VerifyEmailViewModel {
    @MainActor
    static var preview: VerifyEmailViewModel {
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
            func execute(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> {
                return .success(())
            }
        }
        
        class MockVerifySignupOtpUseCase: VerifySignupOtpUseCaseProtocol {
            func execute(email: String, otp: String) async -> Result<Bool, AuthError> {
                return .success(true)
            }
        }
        
        return VerifyEmailViewModel(
            email: "test@linguaquest.com",
            router: MockRouter(),
            sendOtpUseCase: MockSendOtpUseCase(),
            verifySignupOtpUseCase: MockVerifySignupOtpUseCase()
        )
    }
}
