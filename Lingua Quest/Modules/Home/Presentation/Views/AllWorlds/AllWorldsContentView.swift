//
//  AllWorldsContentView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct AllWorldsContentView: View {
    // MARK: - Properties
    let isLoading: Bool
    let selectedFilter: WorldDifficulty?
    let worlds: [WorldUIModel]
    
    var onBackTapped: () -> Void
    var onFilterSelected: (WorldDifficulty?) -> Void
    var onWorldTapped: (WorldUIModel) -> Void
    
    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            AllWorldsTopBar(onBackTapped: onBackTapped)
            
            if isLoading {
                AllWorldsSkeletonView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        
                        AllWorldsFilterRow(selectedFilter: selectedFilter, onFilterSelected: onFilterSelected)
                        
                        WorldsCountLabel(count: worlds.count)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(worlds) { world in
                                Button(action: { onWorldTapped(world) }) {
                                    WorldCardView(item: world)
                                }
                                .buttonStyle(.plain)
                                .disabled(world.isLocked)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
    }
    
    // MARK: - Subviews
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L10n.Worlds.allWorldsTitle)
                .appTextStyle(.displaySmall, color: .appTextHeading)
            Text(L10n.Worlds.allWorldsSubtitle)
                .appTextStyle(.bodyLarge, color: .appTextSecondary)
        }
    }
}

// MARK: - Skeleton Shimmer View
struct AllWorldsSkeletonView: View {
    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Worlds.allWorldsTitle)
                        .appTextStyle(.displaySmall, color: .appTextHeading)
                    Text(L10n.Worlds.allWorldsSubtitle)
                        .appTextStyle(.bodyLarge, color: .appTextSecondary)
                }
                
                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { _ in
                        FilterChip(
                            title: "Medium",
                            dotColor: .appBrandPrimary,
                            isSelected: false,
                            action: {}
                        )
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<6, id: \.self) { _ in
                        WorldCardView(item: WorldUIModel(
                            id: "dummy",
                            title: "Dummy World",
                            uiImage: .kitchen,
                            difficulty: .medium,
                            uiDifficultyLabel: "Medium",
                            uiBadgeColor: .appAccentOrange,
                            progress: 0.5,
                            isCompleted: false,
                            isLocked: false,
                            unlockLevel: nil
                        ))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}

// MARK: - Previews
#Preview("Loading") {
    AllWorldsContentView(
        isLoading: true, selectedFilter: nil, worlds: [],
        onBackTapped: {}, onFilterSelected: { _ in }, onWorldTapped: { _ in }
    )
}

#Preview("Success") {
    AllWorldsContentView(
        isLoading: false,
        selectedFilter: nil,
        worlds: [
            WorldUIModel(id: "kitchen", title: "Kitchen World", uiImage: .kitchen, difficulty: .easy, uiDifficultyLabel: "Easy", uiBadgeColor: .appSemanticSuccess, progress: 1.0, isCompleted: true, isLocked: false, unlockLevel: nil),
            
            WorldUIModel(id: "city", title: "City World", uiImage: .city, difficulty: .medium, uiDifficultyLabel: "Medium", uiBadgeColor: .appAccentOrange, progress: 0.85, isCompleted: false, isLocked: false, unlockLevel: nil),
            
            WorldUIModel(id: "supermarket", title: "Supermarket", uiImage: .kitchen, difficulty: .easy, uiDifficultyLabel: "Easy", uiBadgeColor: .appSemanticSuccess, progress: 0.40, isCompleted: false, isLocked: false, unlockLevel: nil),
            
            WorldUIModel(id: "hospital", title: "Hospital World", uiImage: .city, difficulty: .hard, uiDifficultyLabel: "Hard", uiBadgeColor: .appAccentStreakRed, progress: 0.75, isCompleted: false, isLocked: false, unlockLevel: nil),
            
            WorldUIModel(id: "school", title: "School World", uiImage: .city, difficulty: .medium, uiDifficultyLabel: "Medium", uiBadgeColor: .appAccentOrange, progress: 0.0, isCompleted: false, isLocked: true, unlockLevel: 5),
            
            WorldUIModel(id: "animals", title: "Animals World", uiImage: .kitchen, difficulty: .hard, uiDifficultyLabel: "Hard", uiBadgeColor: .appAccentStreakRed, progress: 0.0, isCompleted: false, isLocked: true, unlockLevel: 10),
            
            WorldUIModel(id: "airport", title: "Airport World", uiImage: .city, difficulty: .hard, uiDifficultyLabel: "Hard", uiBadgeColor: .appAccentStreakRed, progress: 0.0, isCompleted: false, isLocked: true, unlockLevel: 15)
        ],
        onBackTapped: {},
        onFilterSelected: { _ in },
        onWorldTapped: { _ in }
    )
}
