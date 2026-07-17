//
//  LinguaTopExplorersSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct TopExplorersSection: View {
    // MARK: - Properties
    let explorers: [ExplorerEntity]
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
                        Divider().background(Color.appProfileAchievementBorder)
                    }
                }
            }
            .background(Color.appProfileCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appProfileAchievementBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - UI Mapping Extension
private extension ExplorerEntity {
    var uiRank: String {
        "\(rank)"
    }
    
    var uiXPAmount: String {
        let formattedXP = xp.formatted()
        return L10n.Profile.explorerXP(formattedXP)
    }
    
    var isTop: Bool {
        rank == 1
    }
}

// MARK: - Preview
#Preview {
    let mockExplorers = [
        ExplorerEntity(id: "1", rank: 1, name: "Marco Polo", xp: 12450, avatarImage: nil),
        ExplorerEntity(id: "2", rank: 2, name: "Amelia Earhart", xp: 11200, avatarImage: nil),
        ExplorerEntity(id: "3", rank: 3, name: "Ibn Battuta", xp: 9850, avatarImage: nil)
    ]
    
    TopExplorersSection(explorers: mockExplorers) {
        print("View All Explorers Tapped!")
    }
    .padding(.vertical)
    .background(Color.appViewBackground)
}
