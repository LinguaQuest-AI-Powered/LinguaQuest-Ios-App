//
//  LeaderboardRowView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardRowView: View {
    let user: LeaderboardUser
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(user.rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(user.isCurrentUser ? Color.teal : Color.appTextHeading)
                .frame(width: 36, alignment: .leading)
            
            ZStack(alignment: .bottomTrailing) {
                Image(user.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                
                if user.isCurrentUser {
                    ZStack {
                        Circle()
                            .fill(Color.teal)
                            .frame(width: 16, height: 16)
                        Image(systemIcon: .personFill)
                            .foregroundColor(.white)
                            .font(.system(size: 8))
                    }
                    .offset(x: 2, y: 2)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(user.isCurrentUser ? Color.teal : Color.appTextHeading)
                
                Text(user.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(user.isCurrentUser ? Color.teal.opacity(0.8) : .gray)
            }
            
            Spacer()
            
            if user.isCurrentUser {
                Text(L10n.Leaderboard.you)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.teal.opacity(0.8))
                    .clipShape(Capsule())
            }
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(user.xp)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(user.isCurrentUser ? Color.teal : Color.appTextHeading)
                
                Text("XP")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(user.isCurrentUser ? Color.teal.opacity(0.8) : .gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(user.isCurrentUser ? Color.teal.opacity(0.05) : Color.appSurfaceCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(user.isCurrentUser ? Color.teal : Color.gray.opacity(0.2), lineWidth: 2)
        )
    }
}

#Preview {
    VStack {
        LeaderboardRowView(user: LeaderboardUser(id: "98", rank: 98, name: "Ferdinand M.", title: "Novice", image: "user1", xp: 2900, avatarName: "beginner", isCurrentUser: false))
        LeaderboardRowView(user: LeaderboardUser(id: "100", rank: 100, name: "Explorer Sam", title: "Adventurer", image: "user3", xp: 3150, avatarName: "intermediate", isCurrentUser: true))
    }
    .padding()
}
