//
//  HomeExploreWorldsSection.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeExploreWorldsSection: View {
    @Bindable var viewModel: HomeViewModel
    let displayWorlds: [WorldUIModel]
    let animateItems: Bool
    
    var body: some View {
        Group {
            HomeSectionHeaderView(
                title: L10n.Home.exploreWorlds,
                actionTitle: L10n.Home.seeMore,
                onActionTapped: { viewModel.navigateToAllWorlds() }
            )
            .padding(.horizontal, 20)
            .id(TutorialStepType.exploreWorlds)
            .tutorialStep(.exploreWorlds)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(displayWorlds) { item in
                        Button(action: {
                            viewModel.navigateToGameLevels(
                                worldId: Int(item.id) ?? 0,
                                worldName: item.title,
                                languageId: viewModel.languageViewModel.activeLanguage?.id ?? 1
                            )
                        }) {
                            WorldCardView(item: item)
                                .frame(width: 204)
                        }
                        .buttonStyle(HomeScaleButtonStyle())
                        .disabled(item.isLocked)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
        .offset(y: animateItems ? 0 : 30)
        .opacity(animateItems ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateItems)
    }
}
