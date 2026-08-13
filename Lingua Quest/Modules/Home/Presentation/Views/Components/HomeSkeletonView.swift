//
//  HomeSkeletonView.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

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
                HomeSectionHeaderView(
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
