//
//  LinguaLeaderboardRow.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct LeaderboardRow: View {
    // MARK: - Properties
    let rank: String
    let name: String
    let xpAmount: String
    let avatarImage: String?
    let isTop: Bool
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            
            // Rank Number
            Text(rank)
                .appTextStyle(.bodyBold, color: .appProfileRankBrown)
                .frame(width: 24)
            
            // Avatar
            LinguaAvatarView(
                imageName: avatarImage,
                size: 48,
                showBadge: false
            )
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .appTextStyle(.bodyBold, color: .appProfileTextSectionTitle)
                
                Text(xpAmount)
                    .appTextStyle(.caption12Semibold, color: .appProfileTextAchievementDesc)
            }
            
            Spacer()
            
            // Top Explorer Badge
            if isTop {
                Image(systemIcon: .rosette)
                    .foregroundColor(.appProfileTopBadgeOrange)
                    .font(.system(size: 20))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        LeaderboardRow(
            rank: "1",
            name: "Marco Polo",
            xpAmount: "12,450 XP",
            avatarImage: nil,
            isTop: true
        )
        
        Divider().background(Color.appProfileAchievementBorder)
        
        LeaderboardRow(
            rank: "2",
            name: "Amelia Earhart",
            xpAmount: "11,200 XP",
            avatarImage: nil,
            isTop: false
        )
    }
    .padding()
}
