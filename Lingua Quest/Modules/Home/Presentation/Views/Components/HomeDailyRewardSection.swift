//
//  HomeDailyRewardSection.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeDailyRewardSection: View {
    @Bindable var viewModel: HomeViewModel
    let shouldShowDailyReward: Bool
    let isAnimated: Bool
    @Binding var showDailyRewardDialog: Bool
    let playSound: () -> Void
    
    var body: some View {
        VStack {
            if shouldShowDailyReward {
                DailyBonusCardView {
                    playSound()
                    showDailyRewardDialog = true
                }
                .tutorialStep(.dailyReward)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                        removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.8))
                    )
                )
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.8), value: isAnimated)
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: viewModel.dailyRewardViewModel.isClaimed)
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: viewModel.dailyRewardViewModel.reward != nil)
        .zIndex(1)
    }
}
