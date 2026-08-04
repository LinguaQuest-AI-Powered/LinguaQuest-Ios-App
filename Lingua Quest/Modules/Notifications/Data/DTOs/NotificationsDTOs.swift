//
//  NotificationsDTOs.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

// MARK: - Device Token Registration
struct DeviceTokenRequestDTO: Codable {
    let token: String
    let platform: String
}

// MARK: - Notification Models
struct NotificationDTO: Codable {
    let id: Int
    let type: String
    let title: String
    let body: String
    let isRead: Bool
    let createdAt: String
}

struct NotificationsPageDTO: Codable {
    let notifications: [NotificationDTO]
    let page: Int
    let size: Int
    let totalElements: Int
}

struct UnreadCountDTO: Codable {
    let count: Int
}
