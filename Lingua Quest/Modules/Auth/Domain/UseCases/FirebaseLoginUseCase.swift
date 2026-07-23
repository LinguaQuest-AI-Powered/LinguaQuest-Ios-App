//
//  FirebaseLoginUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation

protocol FirebaseLoginUseCaseProtocol {
    func execute(idToken: String) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError>
}

final class FirebaseLoginUseCase: FirebaseLoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(idToken: String) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError> {
        await repository.loginWithFirebase(idToken: idToken)
    }
}
