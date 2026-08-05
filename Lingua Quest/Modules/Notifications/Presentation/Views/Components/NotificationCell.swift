//
//  NotificationCell.swift
//  Lingua Quest
//
//  Created by siam on 05/08/2026.
//

import SwiftUI

struct NotificationCell: View {
    let notification: NotificationEntity
    var onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 56, height: 56)
                    // 3D effect on icon
                    .shadow(color: iconBackgroundColor.opacity(0.6), radius: 0, x: 0, y: 4)
                
                Image(systemIcon: iconForType)
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .appTextStyle(.bodyBold, color: .appTextHeading)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemIcon: .xmark)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.appTextSecondary.opacity(0.6))
                            .padding(6)
                            .background(Circle().fill(Color.appSurfaceCardMuted.opacity(0.5)))
                    }
                }
                
                Text(notification.body)
                    .appTextStyle(.caption, color: .appTextSecondary)
                    .lineLimit(3)
                    .padding(.trailing, 8)
                
                HStack {
                    Text(timeAgoDisplay())
                        .appTextStyle(.microBold, color: .appTextSecondary.opacity(0.7))
                    
                    Spacer()
                    
                    if !notification.isRead {
                        Circle()
                            .fill(Color.appBrandPrimary)
                            .frame(width: 12, height: 12)
                            .shadow(color: Color.appBrandPrimary.opacity(0.5), radius: 0, x: 0, y: 2)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(notification.isRead ? Color.appSurfaceCard : Color.appBrandPrimary.opacity(0.1))
                // Hard 3D shadow for game aesthetic
                .shadow(color: notification.isRead ? Color.appBorderLight : Color.appBrandPrimary.opacity(0.35), radius: 0, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(notification.isRead ? Color.appBorderLight : Color.appBrandPrimary.opacity(0.6), lineWidth: 2)
        )
        .padding(.horizontal, 4) // prevent shadow clipping
        .padding(.bottom, 6)     // prevent shadow clipping
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
