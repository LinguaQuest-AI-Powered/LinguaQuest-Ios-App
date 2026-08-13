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
                            if viewModel.continueLevel != nil || showDailyMission {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        if let continueLevel = viewModel.continueLevel {
                                            ObjectDetectionCardView(
                                                worldName: continueLevel.worldName,
                                                targetWord: continueLevel.word,
                                                levelOrder: continueLevel.levelOrder ?? 1,
                                                totalLevels: viewModel.homeData?.activeLanguage.exploreWorlds
                                                    .first(where: { $0.id == continueLevel.worldId })?.totalLevels ?? 10,
                                                isLoading: viewModel.isContinueLevelLoading,
                                                action: {
                                                    Task {
                                                        await viewModel.onObjectDetectionTapped()
                                                    }
                                                }
                                            )
                                            .frame(width: (viewModel.continueLevel != nil && showDailyMission) ? UIScreen.main.bounds.width - 60 : UIScreen.main.bounds.width - 40)
                                            .id(TutorialStepType.currentLesson)
                                            .tutorialStep(.currentLesson)
                                        }

                                        if showDailyMission {
                                            DailyMissionCard(
                                                viewModel: viewModel.dailyMissionCardViewModel
                                            )
                                            .frame(width: (viewModel.continueLevel != nil && showDailyMission) ? UIScreen.main.bounds.width - 60 : UIScreen.main.bounds.width - 40)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 8)
                                }
                                .offset(y: isAnimated ? 0 : 30)
                                .opacity(isAnimated ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.08), value: isAnimated)
                            }

                            Group {
                                SectionHeaderView(
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
                
                VStack {
                    if shouldShowDailyReward {
                        DailyBonusCardView {
                            soundPlayer.play(sound: .dailyReward)
                            showDailyRewardDialog = true
                        }
                        .tutorialStep(.dailyReward)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                                removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.8))
                            )
                        )
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.8), value: isAnimated)
                .animation(.spring(response: 0.6, dampingFraction: 0.75), value: viewModel.dailyRewardViewModel.isClaimed)
                .animation(.spring(response: 0.6, dampingFraction: 0.75), value: viewModel.dailyRewardViewModel.reward != nil)
                .zIndex(1)
                
                Button(action: { showMyLanguagesSheet = true }) {
                    Image(asset: .world)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.appAccentTeal, .appSemanticSuccess],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(Circle().stroke(Color.appGlowTeal.opacity(0.42), lineWidth: 2))
                        .clipShape(Circle())
                        .shadow(color: Color.appGlowTeal.opacity(0.24), radius: 14, x: 0, y: 6)
                        .scaleEffect(pulseWorldButton ? 1.04 : 0.96)
                }
                .buttonStyle(HomeScaleButtonStyle())
                .tutorialStep(.switchLanguage)
                .padding(.trailing, 20)
                .padding(.bottom, 100)
                .offset(y: isAnimated ? 0 : 50)
                .opacity(isAnimated ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6), value: isAnimated)
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

struct HomeScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
        }
    }
    
    struct SectionHeaderView: View {
        let title: String
        let actionTitle: String
        var onActionTapped: () -> Void = {}
        
        var body: some View {
            HStack {
                Text(title)
                    .font(AppTextStyle.displaySmall.font)
                    .foregroundColor(Color.appTextHeading)
                
                Spacer()
                
                Button(action: onActionTapped) {
                    HStack(spacing: 4) {
                        Text(actionTitle)
                            .font(AppTextStyle.bodyBold.font)
                        Image(systemIcon: .rightChevron)
                            .font(AppTextStyle.captionMedium.font)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                    .foregroundColor(Color.appTextHeading)
                }
            }
        }
    }
struct HomeSkeletonView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            LearningCardView(
                flagEmoji: "🇪🇸",
                title: L10n.Home.currentlyLearning,
                languageName: "Spanish",
                level: 1,
                streakDays: 0,
                progressPercent: 60
            )
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ObjectDetectionCardView(
                        worldName: nil,
                        targetWord: nil,
                        levelOrder: 1,
                        totalLevels: 10,
                        action: {}
                    )
                    .frame(width: UIScreen.main.bounds.width - 60)
                    
                    // Daily Mission Placeholder
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.2)).frame(width: 100, height: 20)
                                RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.2)).frame(width: 180, height: 24)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 18).padding(.top, 18)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.2)).frame(height: 72)
                            Circle().fill(Color.gray.opacity(0.2)).frame(width: 80, height: 80).padding(.leading, 8)
                        }
                        .padding(.horizontal, 18).padding(.top, 10).padding(.bottom, 14)
                        
                        Spacer(minLength: 0)
                        
                        RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.2)).frame(height: 50)
                            .padding(.horizontal, 18).padding(.bottom, 18)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.95 : 0.98))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(
                                Color.appAccentOrange.opacity(colorScheme == .dark ? 0.25 : 0.18),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(
                        color: Color.appAccentOrange.opacity(colorScheme == .dark ? 0.12 : 0.08),
                        radius: 20, x: 0, y: 10
                    )
                    .frame(width: UIScreen.main.bounds.width - 60)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            
            Group {
                SectionHeaderView(
                    title: L10n.Home.exploreWorlds,
                    actionTitle: L10n.Home.seeMore,
                    onActionTapped: {}
                )
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.appSurfaceCard)
                                .frame(width: 204, height: 260)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
            }
            
            Color.clear.frame(height: 100)
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}
