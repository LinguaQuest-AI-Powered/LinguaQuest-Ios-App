//
//  NotificationsRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

protocol NotificationsRepositoryProtocol {
    func registerDevice(token: String) async -> Result<Void, AuthError> // Reusing AuthError or a new DomainError
    func unregisterDevice(token: String) async -> Result<Void, AuthError>
    func getNotifications(page: Int, size: Int) async -> Result<NotificationsPageEntity, AuthError>
    func deleteAllNotifications() async -> Result<Void, AuthError>
    func getUnreadCount() async -> Result<Int, AuthError>
    func markAsRead(id: Int) async -> Result<Void, AuthError>
    func deleteNotification(id: Int) async -> Result<Void, AuthError>
}
