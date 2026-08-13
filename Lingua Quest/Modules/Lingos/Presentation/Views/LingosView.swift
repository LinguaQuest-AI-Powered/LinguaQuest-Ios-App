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
    
    @State private var isAnimated: Bool = false
    
    @AppStorage("hasSeenLingosTutorial") private var hasSeenLingosTutorial: Bool = false
    @State private var showTutorial: Bool = false
    @State private var tutorialBounds: [TutorialStepType: CGRect] = [:]
    
    private let tutorialSteps: [TutorialStepType] = [
        .voicePractice,
        .roleplay,
        .mindReader
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
            AppHeaderView(
                starCount: viewModel.statsService.xp,
                coinCount: viewModel.statsService.coins
            )
            
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
                    .tutorialStep(.mindReader)
                    
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
            }
            .background(
                HomeBackgroundView()
                    .ignoresSafeArea()
            )
            
            if showTutorial {
                TutorialOverlayView(
                    bounds: tutorialBounds,
                    steps: tutorialSteps,
                    isPresented: $showTutorial
                )
            }
        }
        .coordinateSpace(name: "TutorialSpace")
        .onPreferenceChange(TutorialBoundsPreferenceKey.self) { bounds in
            self.tutorialBounds = bounds
        }
        .onAppear {
            viewModel.loadVoiceProgress()
            if !reduceMotion {
                withAnimation {
                    isAnimated = true
                }
            } else {
                isAnimated = true
            }
            
            if !hasSeenLingosTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showTutorial = true
                    hasSeenLingosTutorial = true
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .progressDidUpdate)) { _ in
            viewModel.loadVoiceProgress()
        }
    }
    
}
