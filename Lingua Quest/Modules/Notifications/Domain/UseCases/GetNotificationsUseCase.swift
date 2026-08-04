//
//  GetNotificationsUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol GetNotificationsUseCaseProtocol {
    func execute(page: Int, size: Int) async -> Result<NotificationsPageEntity, AuthError>
}

final class GetNotificationsUseCase: GetNotificationsUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, size: Int) async -> Result<NotificationsPageEntity, AuthError> {
        return await repository.getNotifications(page: page, size: size)
    }
}
