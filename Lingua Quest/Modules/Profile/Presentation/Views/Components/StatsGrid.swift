//
//  StatsGrid.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct StatsGrid: View {
    // MARK: - Properties
    var coinsValue: String
    var xpValue: String
    var streakValue: String
    var worldsValue: String
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // MARK: - Body
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            LinguaStatCard(
                value: coinsValue,
                title: L10n.Profile.coins,
                icon: .dollarsignCircleFill,
                iconColor: .appProfileCoinsIcon
            )
            
            LinguaStatCard(
                value: xpValue,
                title: L10n.Profile.totalXP,
                icon: .starCircleFill,
                iconColor: .appProfileXPIcon
            )
            
            LinguaStatCard(
                value: streakValue,
                title: L10n.Profile.streak,
                icon: .flameFill,
                iconColor: .appProfileStreakIcon
            )
            
            LinguaStatCard(
                value: worldsValue,
                title: L10n.Profile.worlds,
                icon: .globeAmericasFill,
                iconColor: .appProfileWorldsIcon
            )
        }
    }
}

// MARK: - Preview
#Preview {
    StatsGrid(
        coinsValue: "1,250",
        xpValue: "4,500",
        streakValue: "7 Days",
        worldsValue: "2"
    )
    .padding()
    .background(Color.appViewBackground)
}

