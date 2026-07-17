//
//  HomeView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct HomeView: View {
    let worlds: [WorldItem] = [
        .init(title: L10n.Home.kitchenWorld, imageName: .kitchen, difficulty: L10n.Home.difficultyEasy, progress: 0.4, isCompleted: true),
        .init(title: L10n.Home.cityWorld, imageName: .city, difficulty: L10n.Home.difficultyMedium, progress: 0.18, isCompleted: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView() //TODO: delete it
                .background(Color.white.ignoresSafeArea(edges: .top))
                .zIndex(1)

            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        LearningCardView()
                        
                        SectionHeaderView(
                            title: L10n.Home.exploreWorlds,
                            actionTitle: L10n.Home.seeMore
                        )
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(worlds) { item in
                                    WorldCardView(item: item)
                                }
                            }
                        }
                        
                        ContinueLessonCardView()
                        
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }

                Button(action: {}) {
                    Image(asset: .world)
                        .font(AppTextStyle.cardTitle.font)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.appDarkGreen)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
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
                .font(AppTextStyle.buttonBold.font)
                .foregroundColor(Color.appTextBrown)

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
                Image(systemName: "centsign.circle.fill") // Kept as systemName since no coin asset was found
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

struct LearningCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(asset: .spanish)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 46, height: 46)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appBorderBrown, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Home.currentlyLearning)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextBrown)
                    
                    Text(L10n.Onboarding.languageSpanish)
                        .font(AppTextStyle.largeTitle.font)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(L10n.Home.level(12))
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(Color.appTextBrown)
                    
                    HStack(spacing: 4) {
                        Image(systemIcon: .flame)
                            .foregroundColor(Color.appGlowYellow)
                        
                        Text(L10n.Home.daysStreak(7))
                            .font(AppTextStyle.captionMedium.font)
                    }
                }
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appSecondryProgressBar)
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appProgressBar)
                    .frame(width: 165, height: 10)
            }
        }
        .padding(18)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct SectionHeaderView: View {
    let title: String
    let actionTitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTextStyle.headline.font)
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .font(AppTextStyle.buttonBold.font)
                    Image(systemIcon: .chevronDown)
                        .font(AppTextStyle.captionMedium.font)
                }
                .foregroundColor(Color.appTextBrown)
            }
        }
    }
}


struct WorldCardView: View {
    let item: WorldItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(asset: item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text(item.difficulty)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.appDarkGreen))
                        .padding(8)
                }
                
                if item.isCompleted {
                    Image(systemIcon: .checkmark)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Color.appDarkGreen))
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -10, y: -10)
                }
            }
            
            Text(item.title)
                .font(AppTextStyle.subtitleMedium.font)
            
            HStack {
                Text(L10n.Home.progress)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appSecondryProgressBar)
                
                Spacer()
                
                Text("\(Int(item.progress * 100))%")
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appProgressBar)
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appViewBackground)
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appDarkGreen)
                    .frame(width: max(CGFloat(item.progress) * 150, 20), height: 10)
            }
        }
        .padding(12)
        .frame(width: 204)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct ContinueLessonCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.Home.continueLessonTitle)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextBrown)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.appViewBackground)
                        )
                    
                    Text(L10n.Home.lessonApple)
                        .font(AppTextStyle.title.font)
                        .foregroundColor(.black)
                    
                    Text(L10n.Home.lessonAppleDesc)
                        .font(AppTextStyle.buttonMedium.font)
                        .foregroundColor(Color.appTextDarkBlue)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.appViewBackground)
                        .frame(width: 96, height: 96)
                    
                    Image(asset: .apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                    Text(L10n.Home.continueButton)
                        .font(AppTextStyle.subtitleMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appPrimaryColor)
                .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}
