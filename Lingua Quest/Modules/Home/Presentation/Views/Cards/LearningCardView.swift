//
//  LearningCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct LearningCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let flagEmoji: String
    let title: String
    let languageName: String
    let level: Int
    let streakDays: Int
    let progressPercent: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Text(flagEmoji)
                    .font(.system(size: 28))
                    .frame(width: 46, height: 46)
                    .background(Color.appSurfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appBorderBrown, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(Color.appTextSecondary)
                    
                    Text(languageName)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(Color.appTextHeading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(L10n.Home.level(level))
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(Color.appTextSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemIcon: .flameFill)
                            .foregroundColor(Color.red)
                        
                        Text(L10n.Home.daysStreak(streakDays))
                            .font(AppTextStyle.captionMedium.font)
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appSecondaryProgressBar)
                        .frame(height: 10)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.appGlowTeal, .appProgressBar],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * min(max(progressPercent / 100.0, 0), 1.0), height: 10)
                        .shadow(color: Color.appGlowTeal.opacity(colorScheme == .dark ? 0.32 : 0.18), radius: 8, x: 0, y: 0)
                }
            }
            .frame(height: 10)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(colorScheme == .dark ? 0.7 : 0.9), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.22 : 0.07), radius: 16, x: 0, y: 8)
    }
}


#Preview {
    LearningCardView(
        flagEmoji: "🇪🇸",
        title: L10n.Home.currentlyLearning,
        languageName: L10n.Onboarding.languageSpanish,
        level: 12,
        streakDays: 7,
        progressPercent: 75
    )
}
