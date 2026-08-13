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
    let onViewAllExplorers: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            
            // Section Header
            SectionHeader(
                title: L10n.Profile.topExplorersTitle,
                actionTitle: L10n.Profile.viewAll,
                onActionTapped: onViewAllExplorers
            )
            
            // Leaderboard List
            VStack(spacing: 10) { // Space between individual cards
                ForEach(Array(explorers.enumerated()), id: \.element.id) { index, explorer in
                    
                    LeaderboardRow(
                        rank: explorer.uiRank,
                        name: explorer.name,
                        xpAmount: explorer.uiXPAmount,
                        avatarImage: explorer.avatarImage,
                        isTop: explorer.isTop,
                        isCurrentUser: explorer.isCurrentUser
                    )
                }
            }

        }
    }
}

// MARK: - Preview
#Preview {
    let mockExplorers = [
        ExplorerUIModel(id: "1", name: "Marco Polo", uiRank: "1", uiXPAmount: "12450", avatarImage: nil, isTop: true, isCurrentUser: false),
        ExplorerUIModel(id: "2", name: "Amelia Earhart", uiRank: "2", uiXPAmount: "11200", avatarImage: nil, isTop: false, isCurrentUser: true),
        ExplorerUIModel(id: "3", name: "Ibn Battuta", uiRank: "3", uiXPAmount: "9850", avatarImage: nil, isTop: false, isCurrentUser: false)
    ]
    
    TopExplorersSection(explorers: mockExplorers) {
        print("View All Explorers Tapped!")
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
