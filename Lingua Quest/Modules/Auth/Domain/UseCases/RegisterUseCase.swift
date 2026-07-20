//
//  RegisterUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(
        email: String, username: String, password: String,
        nativeLanguage: String, targetLanguage: String
    ) async -> Result<RegisteredAccountEntity, AuthError>
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        email: String, username: String, password: String,
        nativeLanguage: String, targetLanguage: String
    ) async -> Result<RegisteredAccountEntity, AuthError> {
        await repository.register(
            email: email, username: username, password: password,
            nativeLanguage: nativeLanguage, targetLanguage: targetLanguage
        )
    }
}
