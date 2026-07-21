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
    let isCurrentUser: Bool
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            
            // Rank Number
            Text(rank)
                .appTextStyle(.bodyBold, color: isCurrentUser ? .appAccentTeal : .appBrandBrown)
                .lineLimit(1)
                .frame(minWidth: 28, alignment: .leading)
            
            // Avatar
            LinguaAvatarView(
                imageName: avatarImage,
                size: 48,
                showBadge: false
            )
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .appTextStyle(.bodyBold, color: isCurrentUser ? .appAccentTeal : .appTextHeading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("Explorer")
                    .appTextStyle(.micro, color: isCurrentUser ? .appAccentTeal.opacity(0.8) : .appTextSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // XP
            HStack(spacing: 8) {
                Text(xpAmount)
                    .appTextStyle(.bodyBold, color: isCurrentUser ? .appAccentTeal : .appTextHeading)
                
                // Top Explorer Badge
                if isTop {
                    Image(systemIcon: .rosette)
                        .foregroundColor(.appAccentOrange)
                        .font(.system(size: 20))
                }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.white) // Card background
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        // The bottom shadow/border effect from the screenshot
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isCurrentUser ? Color.appAccentTeal : Color.appBorderLight, lineWidth: 0)
        )
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(isCurrentUser ? Color.appAccentTeal : Color.appBrandBrown.opacity(0.15))
                .offset(y: 6) // Thicker bottom border effect
        )
        // Floating YOU badge above the row
        .overlay(alignment: .topTrailing) {
            if isCurrentUser {
                Text("YOU")
                    .appTextStyle(.microBold, color: .white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.appAccentTeal)
                    .clipShape(Capsule())
                    .offset(x: -24, y: -10) // Floats on the top border
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        LeaderboardRow(
            rank: "99",
            name: "Sacagawea",
            xpAmount: "2,750 XP",
            avatarImage: nil,
            isTop: false,
            isCurrentUser: false
        )
        
        LeaderboardRow(
            rank: "100",
            name: "Explorer Sam",
            xpAmount: "3,150 XP",
            avatarImage: nil,
            isTop: false,
            isCurrentUser: true
        )
        
        LeaderboardRow(
            rank: "101",
            name: "Zheng He",
            xpAmount: "2,600 XP",
            avatarImage: nil,
            isTop: false,
            isCurrentUser: false
        )
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
