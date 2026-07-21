//
//  RefreshTokenUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol RefreshTokenUseCaseProtocol {
    func execute(refreshToken: String) async -> Result<AuthSessionEntity, AuthError>
}

final class RefreshTokenUseCase: RefreshTokenUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(refreshToken: String) async -> Result<AuthSessionEntity, AuthError> {
        await repository.refreshToken(refreshToken: refreshToken)
    }
}
