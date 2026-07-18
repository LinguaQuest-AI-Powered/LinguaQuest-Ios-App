//
//  HomeView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var hasClaimedDailyReward: Bool = false
    @State private var showDailyBonus: Bool = false
    
    let worlds: [WorldItem] = [
        .init(title: L10n.Home.kitchenWorld, imageName: .kitchen, difficulty: L10n.Home.difficultyEasy, progress: 0.4, isCompleted: true),
        .init(title: L10n.Home.cityWorld, imageName: .city, difficulty: L10n.Home.difficultyMedium, progress: 0.18, isCompleted: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(starCount: 15000000, coinCount: 20000)

            ZStack(alignment: .top) {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        LearningCardView()
                            .padding(.horizontal, 20)

                        SectionHeaderView(
                            title: L10n.Home.exploreWorlds,
                            actionTitle: L10n.Home.seeMore
                        )
                        .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(worlds) { item in
                                    WorldCardView(item: item)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }

                        ContinueLessonCardView()
                            .padding(.horizontal, 20)

                        Color.clear.frame(height: 100)
                    }
                    .padding(.top, 12)
                }

                Button(action: {}) {
                    Image(asset: .world)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.appSemanticSuccess)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                }
                
                if showDailyBonus && !hasClaimedDailyReward {
                    DailyBonusCardView {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDailyBonus = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            hasClaimedDailyReward = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
        .onAppear {
            if !hasClaimedDailyReward {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        showDailyBonus = true
                    }
                }
            }
        }
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


struct HomeBackgroundView: View {
    var body: some View {
        Image(asset: .homeBackground)
            .resizable()
            .scaledToFill()
            .clipped()
    }
}

struct SectionHeaderView: View {
    let title: String
    let actionTitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTextStyle.displaySmall.font)
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .font(AppTextStyle.bodyBold.font)
                    Image(systemIcon: .chevronDown)
                        .font(AppTextStyle.captionMedium.font)
                }
                .foregroundColor(Color.appTextSecondary)
            }
        }
    }
}

