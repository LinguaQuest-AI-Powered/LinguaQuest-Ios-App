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
        VStack(spacing: -16) {
            SpeechBubbleView(text: L10n.SpeakingLab.feedbackNeedsWork, isAnimated: true, animationDelay: 0.5)
                .padding(.horizontal, 40)
            
            DialogCardContainer(mascotImage: .weakPasswordBird) {
                VStack(spacing: 24) {
                    Text(L10n.Game.notQuite)
                    .appTextStyle(.displayMedium, color: .appBrandBrown)
                
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
                        action: { viewModel.onRetry() },
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
}
