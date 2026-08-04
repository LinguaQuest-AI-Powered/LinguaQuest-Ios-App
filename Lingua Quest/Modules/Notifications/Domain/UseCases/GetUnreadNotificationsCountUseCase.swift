//
//  GetUnreadNotificationsCountUseCase.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol GetUnreadNotificationsCountUseCaseProtocol {
    func execute() async -> Result<Int, AuthError>
}

final class GetUnreadNotificationsCountUseCase: GetUnreadNotificationsCountUseCaseProtocol {
    private let repository: NotificationsRepositoryProtocol
    
    init(repository: NotificationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Int, AuthError> {
        return await repository.getUnreadCount()
    }
}
