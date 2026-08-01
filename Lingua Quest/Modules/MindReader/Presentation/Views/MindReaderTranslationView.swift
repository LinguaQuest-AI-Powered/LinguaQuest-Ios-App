//
//  MindReaderTranslationView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderTranslationView: View {
    @State var viewModel: MindReaderTranslationViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                MindReaderHeaderView(
                    action: { viewModel.goBack() },
                    xp: viewModel.statsService.xp,
                    coins: viewModel.statsService.coins
                )
                
                Spacer()
                
                // Bird & Bubble Section (Decoupled to fix overlap)
                VStack(spacing: 12) {
                    
                    // Floating Speech Bubble (Placed ABOVE the card container)
                    SpeechBubbleView(
                        text: L10n.MindReader.translationPrompt,
                        isAnimated: true,
                        animationDelay: 0.3
                    )
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(1)
                    
                    // Translation Challenge Card
                    DialogCardContainer(
                        mascotImage: .mindThinkingBird
                        // speechBubbleText is purposely omitted here to prevent overlap
                    ) {
                        VStack(spacing: 24) {
                            
                            // Title
                            Text(L10n.MindReader.translateThisWord)
                                .appTextStyle(.displayLarge, color: .appBrandBrownDark)
                                .padding(.top, 16)
                            
                            // Word to Translate
                            Text(viewModel.wordToTranslate)
                                .appTextStyle(.displayMedium, color: .appBrandBrownDark)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color.appSurfaceCardMuted)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.appBrandPrimary, lineWidth: 2)
                                )
                                .cornerRadius(16)
                            
                            // Options Buttons
                            VStack(spacing: 12) {
                                ForEach(viewModel.options, id: \.self) { option in
                                    CustomButton(
                                        type: .secendry,
                                        text: option,
                                        action: { viewModel.onOptionTapped(option) },
                                        textStyle: .bodyLargeBold
                                    )
                                }
                            }
                        }
                    }
                    .zIndex(0)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview("LightTheme") {
    MindReaderTranslationView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderTranslationView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
