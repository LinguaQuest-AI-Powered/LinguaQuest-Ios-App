//
//  LeaderboardListView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardListView: View {
    let users: [LeaderboardUser]
    let isLoadingPreviousPage: Bool
    let isLoadingMore: Bool
    let onReachTop: (LeaderboardUser) -> Void
    let onReachBottom: (LeaderboardUser) -> Void

    @State private var appear = false

    var body: some View {
        LazyVStack(spacing: 12) {
            if isLoadingPreviousPage {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.appBrandPrimary)
                        .padding(.vertical, 12)
                    Spacer()
                }
            }

            ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                LeaderboardRow(
                    rank: "\(user.rank)",
                    name: user.name,
                    xpAmount: "\(user.xp) XP",
                    avatarImage: user.image.isEmpty ? nil : user.image,
                    isTop: user.rank <= 3,
                    isCurrentUser: user.isCurrentUser
                )
                    .id(user.id)
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : 50)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(min(Double(index) * 0.05, 0.4)),
                        value: appear
                    )
                    .onAppear {
                        if index < 3 {
                            onReachTop(user)
                        }
                        if index >= users.count - 3 {
                            onReachBottom(user)
                        }
                    }
            }

            if isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.appBrandPrimary)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
        .onAppear {
            appear = true
        }
    }
}

#Preview {
    ScrollView {
        LeaderboardListView(
            users: [
                LeaderboardUser(id: "98", rank: 98, name: "Ferdinand M.", title: "Novice", image: "", xp: 2900, avatarName: "beginner", isCurrentUser: false),
                LeaderboardUser(id: "100", rank: 100, name: "Explorer Sam", title: "Adventurer", image: "", xp: 3150, avatarName: "intermediate", isCurrentUser: true)
            ],
            isLoadingPreviousPage: false,
            isLoadingMore: false,
            onReachTop: { _ in },
            onReachBottom: { _ in }
        )
    }
}
