//
//  LoginUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError>
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async -> Result<(session: AuthSessionEntity, user: UserEntity), AuthError> {
        await repository.login(email: email, password: password)
    }
}
