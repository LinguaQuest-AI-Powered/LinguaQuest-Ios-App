//
//  LinguaTopExplorersSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct TopExplorersSection: View {
    // MARK: - Properties
    let explorers: [ExplorerUIModel]
    var onViewAllTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            
            // Section Header
            SectionHeader(
                title: L10n.Profile.topExplorersTitle,
                actionTitle: L10n.Profile.viewAll,
                onActionTapped: onViewAllTapped
            )
            
            // Leaderboard List
            VStack(spacing: 16) { // Space between individual cards
                ForEach(Array(explorers.enumerated()), id: \.element.id) { index, explorer in
                    
                    LeaderboardRow(
                        rank: explorer.uiRank,
                        name: explorer.name,
                        xpAmount: explorer.uiXPAmount,
                        avatarImage: "user2",
                        isTop: explorer.isTop,
                        isCurrentUser: explorer.isCurrentUser // Passing the new property
                    )
                }
            }

        }
    }
}

// MARK: - Preview
#Preview {
    let mockExplorers = [
        ExplorerUIModel(id: "1", name: "Marco Polo", uiRank: "1", uiXPAmount: "12,450 XP", avatarImage: nil, isTop: true, isCurrentUser: false),
        ExplorerUIModel(id: "2", name: "Amelia Earhart", uiRank: "2", uiXPAmount: "11,200 XP", avatarImage: nil, isTop: false, isCurrentUser: true),
        ExplorerUIModel(id: "3", name: "Ibn Battuta", uiRank: "3", uiXPAmount: "9,850 XP", avatarImage: nil, isTop: false, isCurrentUser: false)
    ]
    
    TopExplorersSection(explorers: mockExplorers) {
        print("View All Explorers Tapped!")
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
