//
//  AllWorldsFilterRow.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct AllWorldsFilterRow: View {
    let selectedFilter: WorldDifficulty?
    var onFilterSelected: (WorldDifficulty?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: L10n.Worlds.filterAll,
                    dotColor: nil,
                    isSelected: selectedFilter == nil,
                    action: { onFilterSelected(nil) }
                )
                
                ForEach(WorldDifficulty.allCases, id: \.self) { difficulty in
                    FilterChip(
                        title: WorldUIMapper.label(for: difficulty),
                        dotColor: WorldUIMapper.badgeColor(for: difficulty),
                        isSelected: selectedFilter == difficulty,
                        action: { onFilterSelected(difficulty) }
                    )
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AllWorldsFilterRow(selectedFilter: .easy, onFilterSelected: { _ in })
        .padding()
        .background(Color.appBackgroundWarm)
}
