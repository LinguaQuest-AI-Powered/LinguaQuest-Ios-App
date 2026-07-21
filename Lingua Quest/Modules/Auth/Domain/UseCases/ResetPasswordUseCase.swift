//
//  ResetPasswordUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol ResetPasswordUseCaseProtocol {
    func execute(resetToken: String, newPassword: String) async -> Result<Void, AuthError>
}

final class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(resetToken: String, newPassword: String) async -> Result<Void, AuthError> {
        await repository.resetPassword(resetToken: resetToken, newPassword: newPassword)
    }
}
