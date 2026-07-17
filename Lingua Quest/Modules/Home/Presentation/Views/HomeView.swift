//
//  HomeView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct HomeView: View {
    let worlds: [WorldItem] = [
        .init(title: "Kitchen World", imageName: .kitchen, difficulty: "EASY", progress: 0.4, isCompleted: true),
        .init(title: "City World", imageName: .city, difficulty: "MEDIUM", progress: 0.18, isCompleted: false)
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
                            title: "Explore Worlds",
                            actionTitle: "See more"
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
                
                // Floating Action Button
                Button(action: {}) {
                    Image(asset: .world)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.appDarkGreen)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }.background(
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
                .overlay(Circle().stroke(Color.brown.opacity(0.3), lineWidth: 1))

            Text("LinguaQuest")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.58, green: 0.35, blue: 0.1))

            Spacer()

            HStack(spacing: 4) {
                Image("star")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("1,250")
                    .font(.system(size: 13, weight: .bold))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(Capsule())

            HStack(spacing: 4) {
                Image(systemName: "centsign.circle.fill")
                    .foregroundColor(Color(red: 0.65, green: 0.45, blue: 0.25))
                Text("45")
                    .font(.system(size: 13, weight: .bold))
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
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.5), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("CURRENTLY LEARNING")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.brown.opacity(0.7))
                    
                    Text("Spanish")
                        .font(.system(size: 34, weight: .bold))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Level 12")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.brown.opacity(0.7))
                    
                    HStack(spacing: 4) {
                        Image(systemIcon: .flame)
                            .foregroundColor(.red)
                        
                        Text("7 Days")
                            .font(.system(size: 13, weight: .semibold))
                    }
                }
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(red: 0.95, green: 0.88, blue: 0.85))
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appDarkGreen)
                    .frame(width: 165, height: 10)
            }
        }
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct SectionHeaderView: View {
    let title: String
    let actionTitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 26, weight: .bold))
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .bold))
                    Image(systemIcon: .chevronDown)
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(Color(red: 0.58, green: 0.35, blue: 0.1))
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
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color(red: 0.18, green: 0.44, blue: 0.38)))
                        .padding(8)
                }
                
                if item.isCompleted {
                    Image(systemIcon: .checkmark)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Color(red: 0.18, green: 0.44, blue: 0.38)))
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -10, y: -10)
                }
            }
            
            Text(item.title)
                .font(.system(size: 18, weight: .medium))
            
            HStack {
                Text("Progress")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.black.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(item.progress * 100))%")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.18, green: 0.44, blue: 0.38))
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(red: 0.95, green: 0.88, blue: 0.85))
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color(red: 0.18, green: 0.44, blue: 0.38))
                    .frame(width: max(CGFloat(item.progress) * 150, 20), height: 10)
            }
        }
        .padding(12)
        .frame(width: 204)
        .background(Color(red: 0.98, green: 0.96, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct ContinueLessonCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CONTINUE LESSON")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.58, green: 0.35, blue: 0.1))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color(red: 0.95, green: 0.88, blue: 0.82))
                        )
                    
                    Text("Apple")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Noun • La Pomme")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.95, green: 0.88, blue: 0.85))
                        .frame(width: 96, height: 96)
                    
                    Image(asset: .apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                    Text("Continue")
                        .font(.system(size: 20, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(red: 0.96, green: 0.64, blue: 0.23))
                .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}
