//
//  MarkNotificationReadUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol MarkNotificationReadUseCaseProtocol {
    func execute(id: Int) async -> Result<Void, AuthError>
}

final class MarkNotificationReadUseCase: MarkNotificationReadUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async -> Result<Void, AuthError> {
        return await repository.markAsRead(id: id)
    }
}
