//
//  NotificationsAssembly.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation
import Swinject

final class NotificationsAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Data Layer
        container.register(NotificationsRemoteDataSourceProtocol.self) { resolver in
            NotificationsRemoteDataSource(apiClient: resolver.resolve(APIClientProtocol.self)!)
        }
        
        container.register(NotificationsRepositoryProtocol.self) { resolver in
            NotificationsRepositoryImpl(
                remoteDataSource: resolver.resolve(NotificationsRemoteDataSourceProtocol.self)!
            )
        }
        
        // MARK: - Use Cases
        container.register(RegisterDeviceUseCaseProtocol.self) { resolver in
            RegisterDeviceUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(UnregisterDeviceUseCaseProtocol.self) { resolver in
            UnregisterDeviceUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(GetNotificationsUseCaseProtocol.self) { resolver in
            GetNotificationsUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(DeleteAllNotificationsUseCaseProtocol.self) { resolver in
            DeleteAllNotificationsUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(GetUnreadNotificationsCountUseCaseProtocol.self) { resolver in
            GetUnreadNotificationsCountUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(MarkNotificationReadUseCaseProtocol.self) { resolver in
            MarkNotificationReadUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
        
        container.register(DeleteNotificationUseCaseProtocol.self) { resolver in
            DeleteNotificationUseCase(repository: resolver.resolve(NotificationsRepositoryProtocol.self)!)
        }
    }
}
