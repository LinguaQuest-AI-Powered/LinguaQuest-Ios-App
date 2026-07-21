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
    
    @State private var showDailyRewardDialog = false
    @State private var pulseWorldButton = false
    
    @State private var showMyLanguagesSheet = false
    @State private var showAddLanguageScreen = false
    @State private var selectedLanguage: UserLearningLanguage? = UserLearningLanguage(language: Language(code: "es", name: "Spanish", flag: "🇪🇸"), level: 12)
    @State private var userLanguages: [UserLearningLanguage] = [
        UserLearningLanguage(language: Language(code: "es", name: "Spanish", flag: "🇪🇸"), level: 12),
        UserLearningLanguage(language: Language(code: "fr", name: "French", flag: "🇫🇷"), level: 4),
        UserLearningLanguage(language: Language(code: "ja", name: "Japanese", flag: "🇯🇵"), level: 3)
    ]
    
    private var displayWorlds: [WorldUIModel] {
        viewModel.displayWorlds
    }
    
    @State private var animateItems: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(
                starCount: viewModel.homeData?.xp ?? 0,
                coinCount: viewModel.homeData?.coins ?? 0
            )

            ZStack(alignment: .bottomTrailing) {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if !viewModel.dailyRewardViewModel.isClaimed && viewModel.dailyRewardViewModel.reward != nil {
                            DailyBonusCardView {
                                showDailyRewardDialog = true
                            }
                            .padding(.horizontal, 20)
                            .offset(y: animateItems ? 0 : 30)
                            .opacity(animateItems ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: animateItems)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        LearningCardView(
                            imageAsset: .spanish,
                            title: L10n.Home.currentlyLearning,
                            languageName: viewModel.homeData?.activeLanguage.name ?? L10n.Onboarding.languageSpanish,
                            level: viewModel.homeData?.activeLanguage.level ?? 1,
                            streakDays: viewModel.homeData?.streakDays ?? 0,
                            progressWidth: CGFloat(viewModel.homeData?.activeLanguage.levelProgressPercent ?? 0) * 1.65
                        )
                            .padding(.horizontal, 20)
                            .offset(y: animateItems ? 0 : 30)
                            .opacity(animateItems ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: animateItems)

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
                                            viewModel.navigateToGameLevels(worldName: item.title)
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
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateItems)

                        ContinueLessonCardView(
                            title: L10n.Home.continueLessonTitle,
                            lessonName: L10n.Home.lessonApple,
                            lessonDescription: L10n.Home.lessonAppleDesc,
                            imageAsset: .appleImage,
                            buttonText: L10n.Home.continueButton,
                            action: {}
                        )
                            .padding(.horizontal, 20)
                            .offset(y: animateItems ? 0 : 30)
                            .opacity(animateItems ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.45), value: animateItems)

                        Color.clear.frame(height: 100)
                    }
                    .padding(.top, 12)
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
                .offset(y: animateItems ? 0 : 50)
                .opacity(animateItems ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6), value: animateItems)
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
        .onAppear {
            withAnimation {
                animateItems = true
            }
            
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulseWorldButton = true
            }
            
            Task {
                await viewModel.loadHomeData()
                await viewModel.dailyRewardViewModel.loadDailyReward()
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
                isPresented: $showMyLanguagesSheet,
                languages: userLanguages,
                selectedLanguage: $selectedLanguage,
                onAddNewLanguage: {
                    showAddLanguageScreen = true
                }
            )
        }
        .fullScreenCover(isPresented: $showAddLanguageScreen) {
            AddLanguageView(userLanguages: $userLanguages)
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
