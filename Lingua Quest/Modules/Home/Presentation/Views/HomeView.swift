//
//  HomeView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(Router.self) var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasClaimedDailyReward: Bool = false
    
    @State private var dailyRewardViewModel = DailyRewardViewModel()
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
    
    let worlds: [WorldItem] = [
            .init(id: "kitchen", title: L10n.Home.kitchenWorld, imageAssetName: "kitchen", difficulty: .easy, progress: 0.4, isCompleted: true),
            
            .init(id: "city", title: L10n.Home.cityWorld, imageAssetName: "city", difficulty: .medium, progress: 0.85, isCompleted: false),
            
            .init(id: "airport", title: "Airport World", imageAssetName: "city", difficulty: .hard, progress: 0.75, isCompleted: false),
            
            .init(id: "supermarket", title: "Supermarket", imageAssetName: "kitchen", difficulty: .easy, progress: 0.15, isCompleted: false)
        ]
    
    private var displayWorlds: [WorldUIModel] {
        worlds.map(WorldUIMapper.map)
    }
    
    @State private var animateItems: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(starCount: 15000000, coinCount: 20000)

            ZStack(alignment: .bottomTrailing) {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if !hasClaimedDailyReward {
                            DailyBonusCardView {
                                showDailyRewardDialog = true
                            }
                            .padding(.horizontal, 20)
                            .offset(y: animateItems ? 0 : 30)
                            .opacity(animateItems ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.0), value: animateItems)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        LearningCardView()
                            .padding(.horizontal, 20)
                            .offset(y: animateItems ? 0 : 30)
                            .opacity(animateItems ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: animateItems)

                        Group {
                            SectionHeaderView(
                                title: L10n.Home.exploreWorlds,
                                actionTitle: L10n.Home.seeMore,
                                onActionTapped: { router.push(.allWorlds) }
                            )
                            .padding(.horizontal, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(displayWorlds) { item in
                                        Button(action: {
                                            router.push(.gameLevels(worldId: 10, worldName: item.title, languageId: 1))
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

                        ContinueLessonCardView()
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
        }
        .appDialog(isPresented: $showDailyRewardDialog) {
            DailyRewardCardContent(
                days: dailyRewardViewModel.timelineDays,
                completedCount: dailyRewardViewModel.completedNodesCount,
                rewardAmount: dailyRewardViewModel.reward.rewardAmount,
                onClaimTapped: {
                    dailyRewardViewModel.claimReward()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDailyRewardDialog = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        hasClaimedDailyReward = true
                    }
                }
            )
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


//TODO: Delete it and use the CustomTopBar instead of this one
struct TopBarView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(asset: .appBarBird)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.appBorderBrown, lineWidth: 1))

            Text(L10n.Components.appName)
                .font(AppTextStyle.bodyBold.font)
                .foregroundColor(Color.appTextSecondary)

            Spacer()

            HStack(spacing: 4) {
                Image(asset: .star)
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("1,250")
                    .font(AppTextStyle.captionMedium.font)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(Capsule())

            HStack(spacing: 4) {
                Image(systemName: "centsign.circle.fill")
                    .foregroundColor(Color.appIconBrown)
                Text("45")
                    .font(AppTextStyle.captionMedium.font)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(Capsule())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
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
