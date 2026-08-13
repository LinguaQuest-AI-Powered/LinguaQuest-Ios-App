//
//  LingosView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 09/08/2026.
//

import SwiftUI

struct LingosView: View {
    @Bindable var viewModel: LingosViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.currentTutorialStep) private var currentTutorialStep
    
    @State private var isAnimated: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
            AppHeaderView(
                starCount: viewModel.statsService.xp,
                coinCount: viewModel.statsService.coins
            )
            
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                    LingosGameCardView(
                        tagText: L10n.SpeakingLab.voicePractice,
                        title: L10n.Home.voicePracticeSubtitle,
                        buttonText: L10n.Home.start,
                        mascotAsset: .micBird,
                        tagColor: .appAccentOrange,
                        action: { viewModel.navigateToVoiceGame() }
                    )
                    .offset(y: isAnimated ? 0 : 30)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isAnimated)
                    .id(TutorialStepType.voicePractice)
                    .tutorialStep(.voicePractice)
                    
                    LingosGameCardView(
                        tagText: L10n.BossLevel.roleplayTag,
                        title: L10n.BossLevel.interactiveScenarios,
                        buttonText: L10n.BossLevel.browseRoleplays,
                        mascotAsset: .bird3,
                        tagColor: .appAccentOrange,
                        action: { viewModel.navigateToRoleplay() }
                    )
                    .offset(y: isAnimated ? 0 : 30)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isAnimated)
                    .id(TutorialStepType.roleplay)
                    .tutorialStep(.roleplay)
                    
                    LingosGameCardView(
                        tagText: L10n.MindReader.mindReaderTag,
                        title: L10n.MindReader.homeTitle,
                        buttonText: L10n.Home.start,
                        mascotAsset: .mindBird,
                        tagColor: .appAccentOrange,
                        action: { viewModel.navigateToMindReader() }
                    )
                    .offset(y: isAnimated ? 0 : 30)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isAnimated)
                    .id(TutorialStepType.mindReader)
                    .tutorialStep(.mindReader)
                    
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .onChange(of: currentTutorialStep) { _, newStep in
                if let step = newStep {
                    withAnimation {
                        proxy.scrollTo(step, anchor: .center)
                    }
                }
            }
        } // closes ScrollViewReader
        } // closes VStack
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
    } // closes ZStack
    .onAppear {
            viewModel.loadVoiceProgress()
            if !reduceMotion {
                withAnimation {
                    isAnimated = true
                }
            } else {
                isAnimated = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .progressDidUpdate)) { _ in
            viewModel.loadVoiceProgress()
        }
    }
    
}
