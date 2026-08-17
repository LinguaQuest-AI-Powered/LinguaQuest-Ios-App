//
//  LeaderboardPodiumView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardPodiumView: View {
    let topUsers: [LeaderboardUser]
    @State private var appear = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if topUsers.count > 1 {
                PodiumCard(user: topUsers[1], type: .silver)
                    .offset(y: appear ? 0 : 150)
                    .opacity(appear ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.2), value: appear)
            } else {
                Spacer().frame(width: 100)
            }
            
            if topUsers.count > 0 {
                VStack(spacing: -15) {
                    Image(asset: .leaderBoardBird)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .zIndex(1)
                        .scaleEffect(appear ? 1 : 0.01)
                        .rotationEffect(.degrees(appear ? 0 : -15))
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.6), value: appear)
                    
                    PodiumCard(user: topUsers[0], type: .gold)
                        .zIndex(0)
                        .offset(y: appear ? 0 : 200)
                        .opacity(appear ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: appear)
                }
            } else {
                Spacer().frame(width: 120)
            }
            
            if topUsers.count > 2 {
                PodiumCard(user: topUsers[2], type: .bronze)
                    .offset(y: appear ? 0 : 150)
                    .opacity(appear ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1), value: appear)
            } else {
                Spacer().frame(width: 100)
            }
        }
        .padding(.horizontal)
        .padding(.top, 24)
        .padding(.bottom, 20)
        .onAppear {
            appear = true
        }
    }
}

enum PodiumType {
    case gold, silver, bronze
    
    var color: Color {
        switch self {
        case .gold: return Color.appPodiumGold
        case .silver: return Color.cyan
        case .bronze: return Color.appPodiumBronze
        }
    }
    
    var height: CGFloat {
        switch self {
        case .gold: return 160
        case .silver: return 130
        case .bronze: return 130
        }
    }
    
    var avatarSize: CGFloat {
        switch self {
        case .gold: return 80
        case .silver: return 60
        case .bronze: return 60
        }
    }
}

struct PodiumCard: View {
    let user: LeaderboardUser
    let type: PodiumType
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 4) {
                Spacer()
                    .frame(height: type.avatarSize / 2 + 12)
                
                Text("#\(user.rank)")
                    .appTextStyle(.headingMediumBold, color: type.color)
                
                Text(user.name)
                    .appTextStyle(.captionBold, color: .appTextHeading)
                    .lineLimit(1)
                
                RewardBadge(type: .xp, value: "\(user.xp)", size: .small)
                
                Spacer(minLength: 0)
            }
            .frame(width: type == .gold ? 120 : 100, height: type.height)
            .background(Color.appSurfaceCard)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(type.color, lineWidth: type == .gold ? 2 : 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(type.color.opacity(0.3))
                    .offset(y: 6)
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.top, type.avatarSize / 2)
            
            ZStack(alignment: .bottomTrailing) {
                LeaderboardAvatarImage(urlString: user.image, size: type.avatarSize)
                    .overlay(Circle().stroke(type.color, lineWidth: 4))
                    .background(Circle().fill(Color.appSurfaceCardWarm))
                
                ZStack {
                    Circle()
                        .fill(type.color)
                        .frame(width: 24, height: 24)
                    Image(systemIcon: .starFill)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .offset(x: 5, y: 5)
            }
        }
    }
}


