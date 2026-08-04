//
//  NotificationsRemoteDataSourceProtocol.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol NotificationsRemoteDataSourceProtocol {
    func registerDevice(token: String) async -> Result<Void, NetworkError>
    func unregisterDevice(token: String) async -> Result<Void, NetworkError>
    func getNotifications(page: Int, size: Int) async -> Result<NotificationsPageDTO, NetworkError>
    func deleteAllNotifications() async -> Result<Void, NetworkError>
    func getUnreadCount() async -> Result<UnreadCountDTO, NetworkError>
    func markAsRead(id: Int) async -> Result<Void, NetworkError>
    func deleteNotification(id: Int) async -> Result<Void, NetworkError>
}
