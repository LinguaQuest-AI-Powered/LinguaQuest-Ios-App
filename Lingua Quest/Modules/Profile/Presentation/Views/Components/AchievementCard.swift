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
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            
            // Icon Badge
            Image(systemIcon: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.appProfileLogoBrown)
                .frame(width: 56, height: 56)
                .background(Color.appProfileLogoBrown.opacity(0.1))
                .clipShape(Circle())
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .appTextStyle(.bodyBold, color: .appProfileTextAchievementTitle)
                
                Text(subtitle)
                    .appTextStyle(.caption, color: .appProfileTextAchievementDesc)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, 26)
        .frame(width: 280)
        .background(Color.appProfileCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appProfileAchievementBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
