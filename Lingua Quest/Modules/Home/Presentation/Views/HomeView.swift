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
    @State private var hasClaimedDailyReward: Bool = false
    @State private var voiceCompleted: Int = 0
    @State private var voiceTotal: Int = 5
    

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
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(
                starCount: viewModel.homeData?.xp ?? 0,
                coinCount: viewModel.homeData?.coins ?? 0
            )

            ZStack(alignment: .bottomTrailing) {
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading && viewModel.homeData == nil {
                        HomeSkeletonView()
                            .padding(.top, 12)
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            if !viewModel.dailyRewardViewModel.isClaimed && viewModel.dailyRewardViewModel.reward != nil {
                                DailyBonusCardView {
                                    showDailyRewardDialog = true
                                }
                                .padding(.horizontal, 20)
                                .offset(y: isAnimated ? 0 : 30)
                                .opacity(isAnimated ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: isAnimated)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }

                            LearningCardView(
                                flagEmoji: viewModel.languageViewModel.activeLanguage?.flagEmoji ?? "🇪🇸",
                                title: L10n.Home.currentlyLearning,
                                languageName: viewModel.languageViewModel.activeLanguage?.name ?? L10n.Onboarding.languageSpanish,
                                level: viewModel.languageViewModel.activeLanguage?.level ?? 1,
                                streakDays: viewModel.homeData?.streakDays ?? 0,
                                progressWidth: CGFloat(viewModel.languageViewModel.activeLanguage?.progressPercent ?? 0) * 1.65
                            )
                                .padding(.horizontal, 20)
                                
                            VoicePracticeCardView(completed: voiceCompleted, total: voiceTotal, action: { router.push(.voiceGame) })
                                .padding(.horizontal, 20)
                                .offset(y: isAnimated ? 0 : 30)
                                .opacity(isAnimated ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: isAnimated)

                            Group {
                                SectionHeaderView(
                                    title: L10n.Home.exploreWorlds,
                                    actionTitle: L10n.Home.seeMore,
                                    onActionTapped: { viewModel.navigateToAllWorlds() }
                                )
                                .padding(.horizontal, 20)

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
                            .offset(y: isAnimated ? 0 : 30)
                            .opacity(isAnimated ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isAnimated)

                            Color.clear.frame(height: 100)
                        }
                        .padding(.top, 12)
                    }
                }

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
        .onAppear {
            if viewModel.homeData != nil {
                animateItems = true
            } else {
                withAnimation {
                    animateItems = true
                }
            }
            
            loadVoiceProgress()
            
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulseWorldButton = true
            }
            
            Task {
                await viewModel.loadHomeData()
                await viewModel.dailyRewardViewModel.loadDailyReward()
                await viewModel.languageViewModel.loadMyLanguages()
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
    }
    
    private func loadVoiceProgress() {
        let useCase = Resolver.shared.resolve(GetVoiceProgressUseCase.self)
        Task {
            do {
                let progress = try await useCase.execute()
                await MainActor.run {
                    voiceCompleted = progress.completed
                    voiceTotal = progress.total
                }
            } catch {
                print("Failed to load voice progress: \(error)")
            }
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
                    Image(systemIcon: .chevronDown)
                        .font(AppTextStyle.captionMedium.font)
                }
                .foregroundColor(Color.appTextHeading)
            }
        }
    }
}

struct HomeSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            LearningCardView(
                flagEmoji: "🇪🇸",
                title: L10n.Home.currentlyLearning,
                languageName: "Spanish",
                level: 1,
                streakDays: 0,
                progressWidth: 100
            )
            .padding(.horizontal, 20)
            
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

            ContinueLessonCardView(
                title: L10n.Home.continueLessonTitle,
                lessonName: L10n.Home.lessonApple,
                lessonDescription: L10n.Home.lessonAppleDesc,
                imageAsset: .appleLogo,
                buttonText: L10n.Home.continueButton,
                action: {}
            )
            .padding(.horizontal, 20)
            
            VoicePracticeCardView(completed: 0, total: 5, action: {})
                .padding(.horizontal, 20)

            Color.clear.frame(height: 100)
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}

