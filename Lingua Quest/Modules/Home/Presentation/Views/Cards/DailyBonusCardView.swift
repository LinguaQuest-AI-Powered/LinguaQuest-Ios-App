//
//  DailyBonusCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct DailyBonusCardView: View {
    var action: () -> Void
    
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
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appBrandPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DailyBonusCardView(
        action: {}
    )
}
