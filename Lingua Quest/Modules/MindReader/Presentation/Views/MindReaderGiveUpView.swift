//
//  MindReaderGiveUpView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderGiveUpView: View {
    @State var viewModel: MindReaderGiveUpViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                MindReaderHeaderView(
                    action: { viewModel.goBack() },
                    xp: viewModel.statsService.xp,
                    coins: viewModel.statsService.coins
                )
                
                Spacer()
                
                // MARK: - Main Content
                VStack(spacing: 12) {
                    
                    // Floating Speech Bubble
                    SpeechBubbleView(
                        text: L10n.MindReader.iGiveUpPrompt,
                        isAnimated: true,
                        animationDelay: 0.3
                    )
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(1)
                    
                    // Main Card
                    DialogCardContainer(
                        mascotImage: .mindGiveUpBird,
                        customMascotSize: CGSize(width: 180, height: 180)
                    ) {
                        VStack(spacing: 24) {
                            
                            // Title
                            Text(L10n.MindReader.categoryVocabularyTitle(viewModel.categoryName))
                                .appTextStyle(.displayLarge, color: .appBrandBrownDark)
                                .multilineTextAlignment(.center)
                                .padding(.top, 16)
                            
                            // MARK: - Word Input Field
                            VStack(spacing: 8) {
                                CustomTextField(
                                    icon: .pencil,
                                    placeholder: L10n.MindReader.enterYourWord,
                                    text: $viewModel.claimedWordInput
                                )
                            }
                            .padding(.horizontal, 16)

                            
                            // MARK: - Actions
                            VStack(spacing: 12) {
                                
                                CustomButton(
                                    type: .primary,
                                    text: L10n.MindReader.submit,
                                    action: { viewModel.onSubmitTapped() },
                                    status: viewModel.claimedWordInput.trimmingCharacters(in: .whitespaces).isEmpty ? .disable : .enable,
                                    trailing: Image(systemIcon: .arrowRight),
                                    textStyle: .bodyLargeBold
                                )
                                
                                CustomButton(
                                    type: .outline(textColor: .appAccentTeal, borderColor: .appAccentTeal),
                                    text: L10n.MindReader.returnToHome,
                                    action: { viewModel.onBackToMenuTapped() },
                                    leading: Image(systemIcon: .houseFill)
                                )
                                .padding(.bottom, 4)
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
        .overlay {
            if viewModel.isProcessing {
                ZStack {
                    Color.appBackgroundWarm.opacity(0.95).ignoresSafeArea()
                    
                    SharedImageLoadingView(
                        imageAsset: .thinkingHardBird,
                        title: L10n.MindReader.thinkingHard,
                        subtitle: L10n.MindReader.thinkingHardSubtitle
                    )
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(100)
            }
        }
        .animation(.easeInOut, value: viewModel.isProcessing)
        .navigationBarHidden(true)
    }
}

