//
//  UnregisterDeviceUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol UnregisterDeviceUseCaseProtocol {
    func execute(token: String) async -> Result<Void, AuthError>
}

final class UnregisterDeviceUseCase: UnregisterDeviceUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(token: String) async -> Result<Void, AuthError> {
        return await repository.unregisterDevice(token: token)
    }
}
