//
//  VoiceFailureView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceFailureView: View {
    @Bindable var viewModel: VoiceGameResultViewModel
    
    var body: some View {
        DialogCardContainer(
            mascotImage: .weakPasswordBird,
            customSpeechBubble: AnyView(
                SpeechBubbleView(
                    text: viewModel.advice.isEmpty ? L10n.SpeakingLab.feedbackNeedsWork : viewModel.advice,
                    isAnimated: true,
                    animationDelay: 0.5
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            )
        ) {
                VStack(spacing: 24) {
                    Text(L10n.Game.notQuite)
                    .dialogTitleStyle()
                
                ScoreCircleView(rating: viewModel.rating)
                
                VStack(spacing: 12) {
                    Text("SENTENCE REVIEW")
                        .font(AppTextStyle.captionBold.font)
                        .foregroundColor(.appTextSecondary)
                    
                    SentenceBreakdownView(words: viewModel.words)
                }
                
                VStack(spacing: 16) {
                    CustomButton(
                        type: .primary,
                        text: L10n.SpeakingLab.retry,
                        action: { viewModel.playAgain() },
                        leading: Image(systemIcon: .arrowLeft)
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
