//
//  VerifyPasswordResetOtpUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol VerifyPasswordResetOtpUseCaseProtocol {
    func execute(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError>
}

final class VerifyPasswordResetOtpUseCase: VerifyPasswordResetOtpUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, otp: String) async -> Result<(resetToken: String, expiresIn: Int), AuthError> {
        await repository.verifyPasswordResetOtp(email: email, otp: otp)
    }
}
