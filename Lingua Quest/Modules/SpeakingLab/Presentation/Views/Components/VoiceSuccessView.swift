//
//  VoiceSuccessView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceSuccessView: View {
    @Bindable var viewModel: VoiceGameResultViewModel
    
    var body: some View {
        DialogCardContainer(
            mascotImage: .perfect,
            customSpeechBubble: AnyView(
                SpeechBubbleView(
                    text: viewModel.advice.isEmpty ? L10n.SpeakingLab.feedbackGreatJob : viewModel.advice,
                    isAnimated: true,
                    animationDelay: 0.5
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            )
        ) {
                VStack(spacing: 24) {
                    Text(L10n.Game.perfect)
                    .dialogTitleStyle()
                
                ScoreCircleView(rating: viewModel.rating)
                
                VStack(spacing: 12) {
                    Text("PRONUNCIATION CHECK")
                        .font(AppTextStyle.captionBold.font)
                        .foregroundColor(.appTextSecondary)
                    
                    SentenceBreakdownView(words: viewModel.words)
                }
                
                // Rewards Pills
                HStack(spacing: 16) {
                    RewardBadge(type: .xp, value: L10n.Game.xpPoints(viewModel.xpPoints), size: .large)
                    RewardBadge(type: .coin, value: L10n.Game.coinsValue(viewModel.coinsEarned), size: .large)
                }
                
                VStack(spacing: 16) {
                    CustomButton(
                        type: .primary,
                        text: L10n.SpeakingLab.continueTitle,
                        action: { viewModel.skip() }
                    )
                    
                    OutlineButton(
                        text: L10n.SpeakingLab.returnHome,
                        action: { viewModel.onReturnHome() }
                    )
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
    }
}
