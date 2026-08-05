//
//  NotificationCell.swift
//  Lingua Quest
//
//  Created by siam on 05/08/2026.
//

import SwiftUI

struct NotificationCell: View {
    let notification: NotificationEntity
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 48, height: 48)
                
                Image(systemIcon: iconForType)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(notification.title)
                    .appTextStyle(.bodyBold, color: .appTextHeading)
                
                Text(notification.body)
                    .appTextStyle(.caption, color: .appTextSecondary)
                    .lineLimit(3)
                
                Text(timeAgoDisplay())
                    .appTextStyle(.captionMedium, color: .appTextSecondary.opacity(0.7))
                    .padding(.top, 2)
            }
            
            Spacer(minLength: 8)
            
            // Unread Indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.appSemanticError)
                    .frame(width: 10, height: 10)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(notification.isRead ? Color.appSurfaceCard : Color.appBrandPrimary.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(notification.isRead ? Color.appBorderLight : Color.appBrandPrimary.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
    
    private var iconForType: Image.SystemIcon {
        switch notification.type {
        case .achievementEarned:
            return .trophyFill
        case .dailyReminder:
            return .timer
        case .newContent:
            return .starFill
        case .other:
            return .bellFill
        }
    }
    
    private var iconBackgroundColor: Color {
        switch notification.type {
        case .achievementEarned:
            return .appAccentGold
        case .dailyReminder:
            return .appBrandPrimary
        case .newContent:
            return .appSemanticSuccess
        case .other:
            return .appAccentTeal
        }
    }
    
    private func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < notification.createdAt {
            return L10n.Notifications.justNow
        } else if hourAgo < notification.createdAt {
            let diff = calendar.dateComponents([.minute], from: notification.createdAt, to: Date()).minute ?? 0
            return L10n.Notifications.minutesAgo(diff)
        } else if dayAgo < notification.createdAt {
            let diff = calendar.dateComponents([.hour], from: notification.createdAt, to: Date()).hour ?? 0
            return L10n.Notifications.hoursAgo(diff)
        } else if weekAgo < notification.createdAt {
            let diff = calendar.dateComponents([.day], from: notification.createdAt, to: Date()).day ?? 0
            return L10n.Notifications.daysAgo(diff)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: notification.createdAt)
        }
    }
}
