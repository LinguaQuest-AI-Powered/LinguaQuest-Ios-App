//
//  RegisterDeviceUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol RegisterDeviceUseCaseProtocol {
    func execute(token: String) async -> Result<Void, AuthError>
}

final class RegisterDeviceUseCase: RegisterDeviceUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(token: String) async -> Result<Void, AuthError> {
        return await repository.registerDevice(token: token)
    }
}
