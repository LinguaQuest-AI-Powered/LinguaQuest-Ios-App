//
//  LinguaAchievementCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct AchievementCard: View {
    // MARK: - Properties
    let title: String
    let subtitle: String
    let icon: Image.SystemIcon
    var isEarned: Bool = true
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            
            // Icon Badge with Lock Overlay
            ZStack(alignment: .bottomTrailing) {
                Image(systemIcon: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isEarned ? Color.appBrandBrown : Color.appTextSecondary)
                    .frame(width: 56, height: 56)
                    .background(isEarned ? Color.appBrandBrown.opacity(0.1) : Color.appSurfaceCardMuted)
                    .clipShape(Circle())
                
                if !isEarned {
                    ZStack {
                        Circle()
                            .fill(Color.appSurfaceCard)
                            .frame(width: 22, height: 22)
                        
                        Image(systemIcon: .lockFill)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.appTextSecondary)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .appTextStyle(.bodyBold, color: isEarned ? .appTextHeading : .appTextSecondary)
                
                Text(subtitle)
                    .appTextStyle(.caption, color: .appTextSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.leading, 16)
        .padding(.trailing, 20)
        .frame(width: 270)
        .background(isEarned ? Color.appSurfaceCardWarm : Color.appSurfaceCardMuted.opacity(0.7))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isEarned ? Color.appBorderLight : Color.appBorderBrown.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Preview
#Preview {
    AchievementCard(
        title: "Wild Explorer",
        subtitle: "Complete 10 lessons in...",
        icon: .trophyFill
    )
    
    AchievementCard(
        title: "Perfect Week",
        subtitle: "7 days streak without...",
        icon: .starFill
    )
}
