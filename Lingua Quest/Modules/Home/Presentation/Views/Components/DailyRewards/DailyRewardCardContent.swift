//
//  DailyRewardCardContent.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Full content of the Daily Reward dialog — composed inside DialogCardContainer
/// so it automatically gets our mascot header, glow background, and shadow
struct DailyRewardCardContent: View {
    // MARK: - Properties
    let days: [DailyRewardDayUIModel]
    let completedCount: Int
    let rewardAmount: Int
    var onClaimTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        DialogCardContainer(
            mascotImage: .mascotReward,
            customMascotSize: CGSize(width: 240, height: 240)
        ) {
            VStack(spacing: 24) {
                header
                    
                
                DailyRewardTimelineView(days: days, completedCount: completedCount)
                    .padding(.horizontal, 4)
                
                RewardAmountBadge(amount: rewardAmount)
                
                CustomButton(
                    type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                    text: L10n.Home.claimReward,
                    action: onClaimTapped,
                    trailing: Image(systemIcon: .gift)
                )
            }
        }
    }
    
    // MARK: - Subviews
    private var header: some View {
        VStack(spacing: 8) {
            Text(L10n.Home.dailyRewardTitle)
                .dialogTitleStyle()
                .multilineTextAlignment(.center)
            
            Text(L10n.Home.dailyRewardSubtitle)
                .dialogSubtitleStyle()
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.appBackgroundPrimary.ignoresSafeArea()
        
        DailyRewardCardContent(
            days: [
                DailyRewardDayUIModel(day: 1, status: .completed),
                DailyRewardDayUIModel(day: 2, status: .completed),
                DailyRewardDayUIModel(day: 3, status: .current),
                DailyRewardDayUIModel(day: 4, status: .locked),
                DailyRewardDayUIModel(day: 5, status: .locked)
            ],
            completedCount: 2,
            rewardAmount: 50,
            onClaimTapped: {}
        )
        .padding(.horizontal, 24)
    }
}
