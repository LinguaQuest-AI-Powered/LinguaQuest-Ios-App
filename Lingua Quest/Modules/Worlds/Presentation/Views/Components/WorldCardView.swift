//
//  WorldCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI

struct WorldCardView: View {
    // MARK: - Properties
    let item: WorldUIModel
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            imageSection
            
            Text(item.title)
                .font(AppTextStyle.bodyLargeMedium.font)
                .foregroundColor(Color.appTextHeading)
                .lineLimit(1)
                .opacity(item.isLocked ? 0.5 : 1)
            
            progressSection
                .opacity(item.isLocked ? 0.5 : 1)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(colorScheme == .dark ? 0.6 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.20 : 0.08), radius: 14, x: 0, y: 8)
    }
    
    // MARK: - Subviews
    private var imageSection: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topLeading) {
                Image(asset: item.uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appSurfaceCard.opacity(0.72), lineWidth: 2)
                    )
                    .opacity(item.isLocked ? 0.5 : 1)
                
                Text(item.uiDifficultyLabel)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(item.uiBadgeColor))
                    .padding(8)
                    .opacity(item.isLocked ? 0.5 : 1)
            }
            
            if item.isCompleted && !item.isLocked {
                completedBadge
                    .offset(x: -10, y: -10)
            }
        }
        .overlay(alignment: .bottom) {
            if item.isLocked {
                lockedBadge.padding(.bottom, 8)
            }
        }
    }
    
    private var completedBadge: some View {
        Image(systemIcon: .checkmark)
            .font(AppTextStyle.micro.font)
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.appSemanticSuccess))
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
    }
    
    private var lockedBadge: some View {
        Text(L10n.Home.unlockAtLevel(item.unlockLevel ?? 0))
            .font(AppTextStyle.microBold.font)
            .foregroundColor(Color.appTextHeading)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.white.opacity(0.85)))
    }
    
    private var progressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text(L10n.Home.progress)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appTextSecondary)
                
                Spacer()
                
                Text("\(Int(item.progress * 100))%")
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(item.uiBadgeColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appBackgroundWarm)
                        .frame(height: 10)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: progressGradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(geometry.size.width * CGFloat(item.progress), 10), height: 10)
                }
            }
            .frame(height: 10)
        }
    }
    
    // MARK: - Helpers
    /// It determines the gradient colors based on difficulty to maintain the glow effect
    private var progressGradientColors: [Color] {
        switch item.difficulty {
        case .easy:
            return [.appGlowTeal, .appSemanticSuccess]
        case .medium:
            return [.appGlowOrange, .appAccentOrange]
        case .hard:
            return [.appGlowRed, .appAccentStreakRed]
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 16) {
        WorldCardView(
            item: WorldUIModel(
                id: "kitchen", title: "Kitchen World", uiImage: .kitchen,
                difficulty: .easy, uiDifficultyLabel: "Easy", uiBadgeColor: .appSemanticSuccess,
                progress: 0.4, isCompleted: true, isLocked: false, unlockLevel: nil
            )
        )
        .frame(width: 204)
        
        WorldCardView(
            item: WorldUIModel(
                id: "airport", title: "Airport World", uiImage: .kitchen,
                difficulty: .hard, uiDifficultyLabel: "Hard", uiBadgeColor: .appAccentStreakRed,
                progress: 0.5, isCompleted: false, isLocked: true, unlockLevel: 15
            )
        )
        .frame(width: 204)
    }
    .padding()
    .background(Color.appBackgroundWarm)
}

