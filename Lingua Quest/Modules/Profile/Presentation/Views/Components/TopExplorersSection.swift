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
            VStack(spacing: 0) {
                ForEach(Array(explorers.enumerated()), id: \.element.id) { index, explorer in
                    
                    LeaderboardRow(
                        rank: explorer.uiRank,
                        name: explorer.name,
                        xpAmount: explorer.uiXPAmount,
                        avatarImage: explorer.avatarImage,
                        isTop: explorer.isTop
                    )
                    
                    if index < explorers.count - 1 {
                        Divider().background(Color.appBorderLight)
                    }
                }
            }
            .background(Color.appSurfaceCardWarm)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appBorderLight, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Preview
#Preview {
    let mockExplorers = [
        ExplorerUIModel(id: "1", name: "Marco Polo", uiRank: "1", uiXPAmount: "12,450 XP", avatarImage: nil, isTop: true),
        ExplorerUIModel(id: "2", name: "Amelia Earhart", uiRank: "2", uiXPAmount: "11,200 XP", avatarImage: nil, isTop: false),
        ExplorerUIModel(id: "3", name: "Ibn Battuta", uiRank: "3", uiXPAmount: "9,850 XP", avatarImage: nil, isTop: false)
    ]
    
    TopExplorersSection(explorers: mockExplorers) {
        print("View All Explorers Tapped!")
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
