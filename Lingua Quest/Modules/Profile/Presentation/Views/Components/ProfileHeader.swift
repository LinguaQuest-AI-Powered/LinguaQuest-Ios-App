//
//  LinguaProfileHeader.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct ProfileHeader: View {
    // MARK: - Properties
    let userName: String
    let userLevel: Int
    let avatarImage: String?
    var onEditTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            
            // Avatar with Edit Button
            LinguaAvatarView(
                imageName: avatarImage,
                size: 112,
                showBadge: true,
                badgeIcon: .pencil,
                onBadgeTapped: onEditTapped
            )
            
            // User Info
            VStack(spacing: 8) {
                Text(userName)
                    .appTextStyle(.profileName, color: .appProfileTextDark)
                
                // MARK: Level Badge
                HStack(spacing: 4) {
                    Image(systemIcon: .medalFill)
                        .font(.system(size: 12))
                    
                    Text(L10n.Profile.userLevel(userLevel))
                        .appTextStyle(.badgeText)
                }
                .foregroundColor(.appProfileLevelBadgeBrown)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.appPrimaryColor)
                        .shadow(color: .appProfileLevelBadgeBrown, radius: 0, x: 0, y: 4)
                )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProfileHeader(
        userName: "Explorer Alex",
        userLevel: 12,
        avatarImage: nil
    ) {
        print("Edit Profile Tapped!")
    }
    .padding()
    .background(Color.appViewBackground)
}
