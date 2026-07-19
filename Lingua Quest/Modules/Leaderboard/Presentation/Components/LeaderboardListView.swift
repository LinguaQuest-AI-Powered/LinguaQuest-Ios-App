//
//  LeaderboardListView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 18/07/2026.
//

import SwiftUI

struct LeaderboardListView: View {
    let users: [LeaderboardUser]
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                LeaderboardRowView(user: user)
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : 50)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(0.7 + min(Double(index) * 0.08, 0.8)),
                        value: appear
                    )
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
    LeaderboardListView(users: [
        LeaderboardUser(id: "98", rank: 98, name: "Ferdinand M.", title: "Novice", image: "user1", xp: 2900, avatarName: "beginner", isCurrentUser: false),
        LeaderboardUser(id: "100", rank: 100, name: "Explorer Sam", title: "Adventurer", image: "user3", xp: 3150, avatarName: "intermediate", isCurrentUser: true)
    ])
}
