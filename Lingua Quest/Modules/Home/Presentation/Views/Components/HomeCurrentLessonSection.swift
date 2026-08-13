//
//  HomeCurrentLessonSection.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeCurrentLessonSection: View {
    @Bindable var viewModel: HomeViewModel
    let showDailyMission: Bool
    let isAnimated: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ObjectDetectionCardView(
                    worldName: viewModel.continueLevel?.worldName,
                    targetWord: viewModel.continueLevel?.word,
                    levelOrder: viewModel.continueLevel?.levelOrder ?? 1,
                    totalLevels: viewModel.continueLevel != nil ? (viewModel.homeData?.activeLanguage.exploreWorlds
                        .first(where: { $0.id == viewModel.continueLevel?.worldId })?.totalLevels ?? 10) : 10,
                    isLoading: viewModel.isContinueLevelLoading,
                    action: {
                        if viewModel.continueLevel?.worldName != nil {
                            Task {
                                await viewModel.onObjectDetectionTapped()
                            }
                        } else {
                            viewModel.navigateToAllWorlds()
                        }
                    }
                )
                .frame(width: showDailyMission ? UIScreen.main.bounds.width - 60 : UIScreen.main.bounds.width - 40)
                .id(TutorialStepType.currentLesson)
                .tutorialStep(.currentLesson)

                if showDailyMission {
                    DailyMissionCard(
                        viewModel: viewModel.dailyMissionCardViewModel
                    )
                    .frame(width: showDailyMission ? UIScreen.main.bounds.width - 60 : UIScreen.main.bounds.width - 40)
                    .id(TutorialStepType.dailyMission)
                    .tutorialStep(.dailyMission)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .offset(y: isAnimated ? 0 : 30)
        .opacity(isAnimated ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.08), value: isAnimated)
    }
}
