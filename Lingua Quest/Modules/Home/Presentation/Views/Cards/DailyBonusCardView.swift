//
//  DailyBonusCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct DailyBonusCardView: View {
    var action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        .frame(width: 56, height: 56)
                    Image(systemIcon: .gift)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Home.dailyStreakBonus)
                        .font(AppTextStyle.bodyLargeMedium.font)
                        .foregroundColor(.white)
                    Text(L10n.Home.claimDailyReward)
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemIcon: .sparkles)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Image(systemIcon: .rightChevron)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .flipsForRightToLeftLayoutDirection(true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color.appBrandPrimary,
                        Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.7 : 0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .shadow(color: Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.3 : 0.15), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DailyBonusCardView(
        action: {}
    )
}
