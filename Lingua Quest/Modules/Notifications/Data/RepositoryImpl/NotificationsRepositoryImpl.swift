//
//  NotificationsRepositoryImpl.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

final class NotificationsRepositoryImpl: NotificationsRepositoryProtocol {
    private let remoteDataSource: NotificationsRemoteDataSourceProtocol
    
    init(remoteDataSource: NotificationsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // Using AuthError or a common domain Error. Since AuthError is widely used in similar use cases, we'll map NetworkError to AuthError for now.
    
    func registerDevice(token: String) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.registerDevice(token: token)
        return result.mapError { AuthDTOMapper.mapError($0) }
    }
    
    func unregisterDevice(token: String) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.unregisterDevice(token: token)
        return result.mapError { AuthDTOMapper.mapError($0) }
    }
    
    func getNotifications(page: Int, size: Int) async -> Result<NotificationsPageEntity, AuthError> {
        let result = await remoteDataSource.getNotifications(page: page, size: size)
        switch result {
        case .success(let dto):
            return .success(mapPageDTO(dto))
        case .failure(let error):
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func deleteAllNotifications() async -> Result<Void, AuthError> {
        let result = await remoteDataSource.deleteAllNotifications()
        return result.mapError { AuthDTOMapper.mapError($0) }
    }
    
    func getUnreadCount() async -> Result<Int, AuthError> {
        let result = await remoteDataSource.getUnreadCount()
        switch result {
        case .success(let dto):
            return .success(dto.count)
        case .failure(let error):
            return .failure(AuthDTOMapper.mapError(error))
        }
    }
    
    func markAsRead(id: Int) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.markAsRead(id: id)
        return result.mapError { AuthDTOMapper.mapError($0) }
    }
    
    func deleteNotification(id: Int) async -> Result<Void, AuthError> {
        let result = await remoteDataSource.deleteNotification(id: id)
        return result.mapError { AuthDTOMapper.mapError($0) }
    }
    
    // MARK: - Mappers
    private func mapPageDTO(_ dto: NotificationsPageDTO) -> NotificationsPageEntity {
        let entities = dto.notifications.map { mapNotificationDTO($0) }
        return NotificationsPageEntity(
            notifications: entities,
            page: dto.page,
            size: dto.size,
            totalElements: dto.totalElements
        )
    }
    
    private func mapNotificationDTO(_ dto: NotificationDTO) -> NotificationEntity {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var parsedDate: Date? = formatter.date(from: dto.createdAt)
        
        if parsedDate == nil {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            parsedDate = isoFormatter.date(from: dto.createdAt) ?? ISO8601DateFormatter().date(from: dto.createdAt)
        }
        
        let date = parsedDate ?? Date()
        
        return NotificationEntity(
            id: dto.id,
            type: NotificationType(fromRawValue: dto.type),
            title: dto.title,
            body: dto.body,
            isRead: dto.isRead,
            createdAt: date
        )
    }
}
