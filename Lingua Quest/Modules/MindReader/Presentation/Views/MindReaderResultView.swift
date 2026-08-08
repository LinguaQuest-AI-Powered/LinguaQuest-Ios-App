//
//  MindReaderResultView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderResultView: View {
    @State var viewModel: MindReaderResultViewModel
    
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
                        text: L10n.MindReader.legendarySkills,
                        isAnimated: true,
                        animationDelay: 0.3
                    )
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(1)
                    
                    // Result Card
                    DialogCardContainer(
                        mascotImage: .mindStumpedBird,
                        customMascotSize: CGSize(width: 180, height: 180)
                    ) {
                        VStack(spacing: 24) {
                            
                            // Title
                            Text(L10n.MindReader.stumpedLingo)
                                .dialogTitleStyle()
                                .padding(.top, 16)
                            
                            // MARK: - Rewards Grid
                            HStack(spacing: 16) {
                                // XP Card
                                RewardCardView(
                                    type: .xp,
                                    title: L10n.MindReader.experience,
                                    amount: viewModel.earnedXP
                                )
                                
                                // Coins Card
                                RewardCardView(
                                    type: .coin,
                                    title: L10n.MindReader.earnings,
                                    amount: viewModel.earnedCoins
                                )
                            }
                            .padding(.horizontal, 16)
                            
                            // MARK: - Actions
                            VStack(spacing: 12) {
                                
                                CustomButton(
                                    type: .primary,
                                    text: L10n.MindReader.playAgain,
                                    action: { viewModel.onPlayAgainTapped() },
                                    leading: Image(systemIcon: .arrowTriangle2Circlepath),
                                    textStyle: .bodyLargeBold
                                )
                                
                                // Outline Button (Return to Home)
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
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
    }
}

