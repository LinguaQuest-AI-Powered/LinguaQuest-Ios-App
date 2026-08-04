//
//  DeleteAllNotificationsUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol DeleteAllNotificationsUseCaseProtocol {
    func execute() async -> Result<Void, AuthError>
}

final class DeleteAllNotificationsUseCase: DeleteAllNotificationsUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Void, AuthError> {
        return await repository.deleteAllNotifications()
    }
}
