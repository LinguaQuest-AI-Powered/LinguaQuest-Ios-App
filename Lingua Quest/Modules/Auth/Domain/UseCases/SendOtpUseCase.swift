//
//  SendOtpUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol SendOtpUseCaseProtocol {
    func execute(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError>
}

final class SendOtpUseCase: SendOtpUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, purpose: OtpPurpose) async -> Result<Void, AuthError> {
        await repository.sendOtp(email: email, purpose: purpose)
    }
}
