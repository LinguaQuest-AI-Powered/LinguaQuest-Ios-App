//
//  HomeView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(Router.self) private var router
    @Environment(\.soundPlayer) private var soundPlayer
    @Environment(\.currentTutorialStep) private var currentTutorialStep
    @State private var hasClaimedDailyReward: Bool = false
    
    
    @State private var showDailyRewardDialog = false
    @State private var pulseWorldButton = false
    
    @State private var showMyLanguagesSheet = false
    @State private var showAddLanguageScreen = false
    
    private var displayWorlds: [WorldUIModel] {
        viewModel.displayWorlds
    }
    
    @State private var animateItems: Bool = false
    
    private var isAnimated: Bool {
        animateItems || viewModel.homeData != nil
    }
    
    private var shouldShowDailyReward: Bool {
        guard isAnimated, !viewModel.dailyRewardViewModel.isClaimed, viewModel.dailyRewardViewModel.reward != nil else { return false }
        
        if let currentStep = currentTutorialStep {
            return currentStep == .dailyReward
        }
        return true
    }
    
    private var showDailyMission: Bool {
        switch viewModel.dailyMissionCardViewModel.state {
        case .completed, .notAvailable:
            return false
        default:
            return true
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
            AppHeaderView(
                starCount: viewModel.statsService.xp,
                coinCount: viewModel.statsService.coins
            )
            .offset(y: isAnimated ? 0 : -20)
            .opacity(isAnimated ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: isAnimated)
            
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        if viewModel.isLoading && viewModel.homeData == nil {
                            HomeSkeletonView()
                                .padding(.top, 12)
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            LearningCardView(
                                flagEmoji: viewModel.languageViewModel.activeLanguage?.flagEmoji ?? "🇪🇸",
                                title: L10n.Home.currentlyLearning,
                                languageName: viewModel.languageViewModel.activeLanguage?.name ?? L10n.Onboarding.languageSpanish,
                                level: viewModel.languageViewModel.activeLanguage?.level ?? 1,
                                streakDays: viewModel.statsService.streakDays,
                                progressPercent: CGFloat(viewModel.languageViewModel.activeLanguage?.progressPercent ?? 0)
                            )
                            .padding(.horizontal, 20)
                            .id(TutorialStepType.learningProgress)
                            .tutorialStep(.learningProgress)
                            .offset(y: isAnimated ? 0 : 30)
                            .opacity(isAnimated ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.05), value: isAnimated)
                            HomeCurrentLessonSection(
                                viewModel: viewModel,
                                showDailyMission: showDailyMission,
                                isAnimated: isAnimated
                            )

                            HomeExploreWorldsSection(
                                viewModel: viewModel,
                                displayWorlds: displayWorlds,
                                animateItems: animateItems
                            )
                            
                        }
                        .padding(.top, 12)
                    }
                }
                .onChange(of: currentTutorialStep) { _, newStep in
                    if let step = newStep {
                        withAnimation {
                            proxy.scrollTo(step, anchor: .center)
                        }
                    }
                }
            }
                
                HomeDailyRewardSection(
                    viewModel: viewModel,
                    shouldShowDailyReward: shouldShowDailyReward,
                    isAnimated: isAnimated,
                    showDailyRewardDialog: $showDailyRewardDialog,
                    playSound: { soundPlayer.play(sound: .dailyReward) }
                )
                
                HomeFloatingButton(
                    showMyLanguagesSheet: $showMyLanguagesSheet,
                    isAnimated: isAnimated,
                    pulseWorldButton: pulseWorldButton
                )
                
                if isAnimated && !viewModel.dailyRewardViewModel.isClaimed && viewModel.dailyRewardViewModel.reward != nil {
                    CoinRainView()
                }
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
    }
    .onAppear {
            if viewModel.homeData != nil {
                animateItems = true
            } else {
                withAnimation {
                    animateItems = true
                }
            }
            
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulseWorldButton = true
            }
            
            Task {
                // Fetch latest data silently in the background when view appears
                async let homeTask: Void = viewModel.loadHomeData(forceRefresh: false)
                async let dailyRewardTask: Void = viewModel.dailyRewardViewModel.loadDailyReward()
                
                await homeTask
                await dailyRewardTask
            }
        }
        .appDialog(isPresented: $showDailyRewardDialog) {
            if let reward = viewModel.dailyRewardViewModel.reward {
                DailyRewardCardContent(
                    days: viewModel.dailyRewardViewModel.timelineDays,
                    completedCount: viewModel.dailyRewardViewModel.completedNodesCount,
                    rewardAmount: reward.rewardCoins,
                    onClaimTapped: {
                        Task {
                            await viewModel.dailyRewardViewModel.claimReward()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showDailyRewardDialog = false
                            }
                        }
                    }
                )
            } else {
                ProgressView()
                    .padding()
            }
        }
        .appDialog(isPresented: Binding(get: { viewModel.dailyRewardViewModel.isClaiming }, set: { _ in })) {
            SharedImageLoadingView(
                imageAsset: .loadingBird,
                title: L10n.Common.loading,
                subtitle: ""
            )
        }
        .customBottomSheet(isPresented: $showMyLanguagesSheet, initialDetent: .custom(ratio: 0.7)) {
            MyLanguagesBottomSheet(
                languageViewModel: viewModel.languageViewModel,
                isPresented: $showMyLanguagesSheet,
                onAddNewLanguage: {
                    showAddLanguageScreen = true
                }
            )
        }
        .fullScreenCover(isPresented: $showAddLanguageScreen) {
            AddLanguageView(languageViewModel: viewModel.languageViewModel)
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text(L10n.Common.error),
                message: Text(viewModel.errorMessage ?? L10n.Network.unknown),
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
    }
}


