//
//  AchievementsView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import SwiftUI

struct AchievementsView: View {
    @State var viewModel: AchievementsViewModel
    
    @State private var isAnimating = false
    @State private var selectedTab: Int = 0 // 0 = ALL, 1 = EARNED, 2 = LOCKED
    @State private var selectedAchievement: FullAchievementUIModel? = nil
    var statusString: String {
        switch selectedTab {
        case 1: return "EARNED"
        case 2: return "LOCKED"
        default: return "ALL"
        }
    }
    
    var filteredAchievements: [FullAchievementUIModel] {
        switch selectedTab {
        case 1:
            return viewModel.achievements.filter { $0.isEarned }
        case 2:
            return viewModel.achievements.filter { !$0.isEarned }
        default:
            return viewModel.achievements
        }
    }
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                   CustomBackButton(action: {
                        viewModel.onBackTapped()
                    })
                    Spacer()
                }
                .overlay(
                    Text(L10n.Achievements.title)
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                )
                .padding(.horizontal, 20)
                .frame(height: 64)
                
                Divider()
                    .background(Color.appBorderBrown)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Trophies Card
                        VStack(spacing: 16) {
                            ZStack {
                                Image(asset: .achivementBird)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                            }
                            
                            VStack(spacing: 8) {
                                Text(L10n.Achievements.myTrophies)
                                    .appTextStyle(.headingLarge, color: .appTextHeading)
                                    
                                Text(L10n.Achievements.subtitle)
                                    .appTextStyle(.body, color: .appTextSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(Color.appSurfaceCard)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.appBorderBrown, lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.appBorderBrown.opacity(0.4))
                                .offset(y: 6)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)
                        
                        // Segment Control
                        HStack(spacing: 0) {
                            segmentButton(title: L10n.Achievements.filterAll, index: 0)
                            segmentButton(title: L10n.Achievements.filterEarned, index: 1)
                            segmentButton(title: L10n.Achievements.filterLocked, index: 2)
                        }
                        .frame(height: 48)
                        .background(Color.appSurfaceCard)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.appBorderBrown, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.4), value: isAnimating)
                        
                        // Grid
                        if viewModel.isLoading {
                            AchievementsSkeletonView()
                                .shimmer()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(filteredAchievements) { achievement in
                                    Button(action: {
                                        selectedAchievement = achievement
                                    }) {
                                        AchievementGridItem(achievement: achievement)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)
                        }
                    }
                }
                
                // Bottom Bar
                VStack(spacing: 16) {
                    Divider().background(Color.appBorderBrown)
                    
                    HStack(spacing: 0) {
                        bottomStatView(value: "\(viewModel.earnedCount)", title: L10n.Achievements.earnedLabel)
                        Divider().frame(height: 30).background(Color.appBorderBrown)
                        bottomStatView(value: "\(viewModel.inProgressCount)", title: L10n.Achievements.inProgressLabel, valueColor: .appTealGreen)
                        Divider().frame(height: 30).background(Color.appBorderBrown)
                        bottomStatView(value: "\(viewModel.xpEarned)", title: L10n.Achievements.xpGainedLabel)
                    }
                    .padding(.top, 8)
                    
                    if let reward = viewModel.weeklyReward {
                        Button(action: {
                            Task {
                                await viewModel.claimWeeklyReward()
                            }
                        }) {
                            HStack {
                                if viewModel.isClaimingReward {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemIcon: .starCircleFill)
                                        .foregroundColor(reward.claimedThisWeek ? .appTextSecondary : .white)
                                    Text(reward.claimedThisWeek ? "Reward Claimed" : L10n.Achievements.claimRewards)
                                        .appTextStyle(.bodyBold, color: reward.claimedThisWeek ? .appTextSecondary : .white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(reward.claimedThisWeek ? Color.appSurfaceCardMuted : Color.appBrandPrimary)
                            .cornerRadius(12)
                        }
                        .disabled(reward.claimedThisWeek || viewModel.isClaimingReward)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }
                }
                .background(Color.appSurfaceCardWarm)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.8), value: isAnimating)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showClaimAlert) {
            Alert(
                title: Text("Rewards Claimed!"),
                message: Text(viewModel.claimAlertMessage),
                dismissButton: .default(Text("Awesome"))
            )
        }
        .customBottomSheet(isPresented: Binding(
            get: { selectedAchievement != nil },
            set: { if !$0 { selectedAchievement = nil } }
        ), initialDetent: .custom(ratio: 0.68)) {
            if let achievement = selectedAchievement {
                AchievementDetailSheet(
                    title: achievement.title,
                    subtitle: achievement.subtitle,
                    uiIcon: achievement.uiIcon,
                    uiIconColor: achievement.uiIconColor,
                    status: achievement.status,
                    progressPercent: achievement.progressPercent,
                    xpReward: achievement.xpReward,
                    coinsReward: achievement.coinsReward,
                    earnedAt: achievement.earnedAt,
                    onClose: {
                        selectedAchievement = nil
                    }
                )
            }
        }
        .onAppear {
            isAnimating = true
            Task {
                await viewModel.loadAchievements(status: "ALL")
            }
        }
    }
    
    private func segmentButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = index
            }
        }) {
            Text(title)
                .appTextStyle(.bodyBold, color: selectedTab == index ? .white : .appTextPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    selectedTab == index ? Color.appAccentTeal : Color.clear
                )
                .clipShape(Capsule())
                .padding(4)
        }
    }
    
    private func bottomStatView(value: String, title: String, valueColor: Color = .appTextHeading) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .appTextStyle(.headingLarge, color: valueColor)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AchievementGridItem: View {
    let achievement: FullAchievementUIModel
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .fill(achievement.uiBgColor)
                        .frame(width: 60, height: 60)
                    
                    Image(systemIcon: achievement.uiIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(achievement.isEarned ? achievement.uiIconColor : .appTextSecondary)
                }
                
                if !achievement.isEarned {
                    ZStack {
                        Circle()
                            .fill(Color.appSurfaceCard)
                            .frame(width: 22, height: 22)
                        
                        Image(systemIcon: .lockFill)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.appTextSecondary)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .appTextStyle(.bodyBold, color: achievement.isEarned ? .appTextHeading : .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                Text(achievement.isEarned ? "COMPLETED" : "\(achievement.progressPercent)%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(achievement.isEarned ? Color.appBadgeTealText : .appTextSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(achievement.isEarned ? Color.appBadgeTealBg : Color.appSurfaceCardMuted)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(achievement.isEarned ? Color.appSurfaceCard : Color.appSurfaceCardMuted.opacity(0.6))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isEarned ? Color.appBorderBrown : Color.appBorderBrown.opacity(0.3), lineWidth: 1)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appBorderBrown.opacity(0.4))
                .offset(y: 4)
        )
    }
}

struct AchievementsSkeletonView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(0..<6, id: \.self) { index in
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.appSurfaceCardMuted.opacity(0.5))
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 8) {
                        Capsule()
                            .fill(Color.appSurfaceCardMuted.opacity(0.5))
                            .frame(height: 16)
                            .padding(.horizontal, 12)
                        
                        Capsule()
                            .fill(Color.appSurfaceCardMuted.opacity(0.5))
                            .frame(width: 60, height: 16)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(Color.appSurfaceCard)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appBorderLight, lineWidth: 0)
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appBorderBrown.opacity(0.4))
                        .offset(y: 4)
                )
                .opacity(1.0 - Double(index) * 0.1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .padding(.top, 16)
    }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel(
        router: Router(),
        getAchievementsUseCase: GetAchievementsUseCase(
            repository: ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(apiClient: APIClient()),
                tokenStorage: SecureTokenStorage()
            )
        ),
        getWeeklyRewardUseCase: GetWeeklyRewardUseCase(
            repository: ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(apiClient: APIClient()),
                tokenStorage: SecureTokenStorage()
            )
        ),
        claimWeeklyRewardUseCase: ClaimWeeklyRewardUseCase(
            repository: ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(apiClient: APIClient()),
                tokenStorage: SecureTokenStorage()
            )
        )
    ))
}
