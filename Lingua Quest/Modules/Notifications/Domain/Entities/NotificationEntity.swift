//
//  NotificationEntity.swift
//  Lingua Quest
//
//  Created by siam on 04/08/2026.
//

import Foundation

enum NotificationType: String {
    case achievementEarned = "ACHIEVEMENT_EARNED"
    case dailyReminder = "DAILY_REMINDER"
    case newContent = "NEW_CONTENT"
    case other = "OTHER"
    
    init(fromRawValue: String) {
        self = NotificationType(rawValue: fromRawValue) ?? .other
    }
}

struct NotificationEntity: Identifiable, Equatable {
    let id: Int
    let type: NotificationType
    let title: String
    let body: String
    let isRead: Bool
    let createdAt: Date
}

struct NotificationsPageEntity: Equatable {
    let notifications: [NotificationEntity]
    let page: Int
    let size: Int
    let totalElements: Int
}
