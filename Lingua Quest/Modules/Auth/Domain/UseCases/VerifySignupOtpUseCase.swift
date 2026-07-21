//
//  VerifySignupOtpUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol VerifySignupOtpUseCaseProtocol {
    func execute(email: String, otp: String) async -> Result<Bool, AuthError>
}

final class VerifySignupOtpUseCase: VerifySignupOtpUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, otp: String) async -> Result<Bool, AuthError> {
        await repository.verifySignupOtp(email: email, otp: otp)
    }
}
