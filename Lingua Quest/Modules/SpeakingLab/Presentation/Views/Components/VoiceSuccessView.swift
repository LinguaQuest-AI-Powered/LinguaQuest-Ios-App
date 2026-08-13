//
//  VoiceSuccessView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceSuccessView: View {
    @Bindable var viewModel: VoiceGameResultViewModel
    @Binding var coinCardCenter: CGPoint
    
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
                    Text(L10n.SpeakingLab.pronunciationCheck)
                        .font(AppTextStyle.captionBold.font)
                        .foregroundColor(.appTextSecondary)
                    
                    SentenceBreakdownView(words: viewModel.words)
                }
                
                // Rewards Grid
                HStack(spacing: 16) {
                    // XP Card
                    RewardCardView(
                        type: .xp,
                        title: L10n.MindReader.experience,
                        amount: viewModel.xpPoints
                    )
                    
                    // Coins Card
                    RewardCardView(
                        type: .coin,
                        title: L10n.MindReader.earnings,
                        amount: viewModel.coinsEarned
                    )
                    .background(GeometryReader { geo in
                        Color.clear.onAppear {
                            let frame = geo.frame(in: .named("global"))
                            DispatchQueue.main.async {
                                self.coinCardCenter = CGPoint(x: frame.midX, y: frame.midY)
                            }
                        }
                    })
                }
                .padding(.horizontal, 16)
                
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
