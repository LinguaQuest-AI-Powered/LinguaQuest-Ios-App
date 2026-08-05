//
//  NotificationsViewModel.swift
//  Lingua Quest
//
//  Created by siam on 05/08/2026.
//

import Foundation
import Observation
import Swinject

@Observable
@MainActor
final class NotificationsViewModel {
    var notifications: [NotificationEntity] = []
    var unreadCount: Int = 0
    var isLoading: Bool = false
    var error: String?
    
    private let getNotificationsUseCase: GetNotificationsUseCaseProtocol
    private let getUnreadCountUseCase: GetUnreadNotificationsCountUseCaseProtocol
    private let markReadUseCase: MarkNotificationReadUseCaseProtocol
    private let deleteUseCase: DeleteNotificationUseCaseProtocol
    private let deleteAllUseCase: DeleteAllNotificationsUseCaseProtocol
    
    private var currentPage = 0
    private let pageSize = 20
    var hasMorePages = true
    
    init(
        getNotificationsUseCase: GetNotificationsUseCaseProtocol,
        getUnreadCountUseCase: GetUnreadNotificationsCountUseCaseProtocol,
        markReadUseCase: MarkNotificationReadUseCaseProtocol,
        deleteUseCase: DeleteNotificationUseCaseProtocol,
        deleteAllUseCase: DeleteAllNotificationsUseCaseProtocol
    ) {
        self.getNotificationsUseCase = getNotificationsUseCase
        self.getUnreadCountUseCase = getUnreadCountUseCase
        self.markReadUseCase = markReadUseCase
        self.deleteUseCase = deleteUseCase
        self.deleteAllUseCase = deleteAllUseCase
    }
    
    func loadInitialData() async {
        isLoading = true
        error = nil
        currentPage = 0
        notifications.removeAll()
        hasMorePages = true
        
        await fetchNotifications()
        await fetchUnreadCount()
        
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        currentPage += 1
        await fetchNotifications()
        isLoading = false
    }
    
    private func fetchNotifications() async {
        let result = await getNotificationsUseCase.execute(page: currentPage, size: pageSize)
        switch result {
        case .success(let pageData):
            if currentPage == 0 {
                notifications = pageData.notifications
            } else {
                notifications.append(contentsOf: pageData.notifications)
            }
            hasMorePages = notifications.count < pageData.totalElements
        case .failure(let error):
            self.error = error.localizedDescription
        }
    }
    
    func fetchUnreadCount() async {
        let result = await getUnreadCountUseCase.execute()
        if case .success(let count) = result {
            unreadCount = count
        }
    }
    
    func markAsRead(_ notification: NotificationEntity) async {
        guard !notification.isRead else { return }
        
        // Optimistic update
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            let updated = NotificationEntity(
                id: notification.id,
                type: notification.type,
                title: notification.title,
                body: notification.body,
                isRead: true,
                createdAt: notification.createdAt
            )
            notifications[index] = updated
            unreadCount = max(0, unreadCount - 1)
        }
        
        _ = await markReadUseCase.execute(id: notification.id)
    }
    
    func deleteNotification(_ notification: NotificationEntity) async {
        // Optimistic delete
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            if !notifications[index].isRead {
                unreadCount = max(0, unreadCount - 1)
            }
            notifications.remove(at: index)
        }
        
        _ = await deleteUseCase.execute(id: notification.id)
    }
    
    func deleteAll() async {
        notifications.removeAll()
        unreadCount = 0
        _ = await deleteAllUseCase.execute()
    }
}
