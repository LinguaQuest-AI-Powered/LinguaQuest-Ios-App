//
//  LogoutUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation

protocol LogoutUseCaseProtocol {
    func execute(refreshToken: String, allDevices: Bool) async -> Result<Void, AuthError>
}

final class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(refreshToken: String, allDevices: Bool) async -> Result<Void, AuthError> {
        await repository.logout(refreshToken: refreshToken, allDevices: allDevices)
    }
}
