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
                        mascotImage: .mindSuccessBird,
                        customMascotSize: CGSize(width: 180, height: 180)
                    ) {
                        VStack(spacing: 24) {
                            
                            // Title
                            Text(L10n.MindReader.stumpedLingo)
                                .appTextStyle(.displayLarge, color: .appBrandBrownDark)
                                .padding(.top, 16)
                            
                            // MARK: - Rewards Grid
                            HStack(spacing: 16) {
                                
                                // XP Card
                                VStack(spacing: 8) {
                                    ZStack {
                                        // Outer glow/background
                                        Circle()
                                            .fill(Color.appAccentGold.opacity(0.2))
                                            .frame(width: 48, height: 48)
                                        
                                        // White backing for the star cutout
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 24, height: 24)
                                        
                                        // Icon (Circle with star cutout)
                                        Image(systemIcon: .starCircleFill)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.appBrandBrownDark)
                                    }
                                    
                                    Text(L10n.MindReader.experience)
                                        .appTextStyle(.captionMedium, color: .appTextSecondary)
                                    
                                    Text(L10n.MindReader.earnedXP(viewModel.earnedXP))
                                        .appTextStyle(.headingMedium, color: .appTextHeading)
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.appSurfaceCard)
                                .cornerRadius(16)
                                .shadow(color: Color.appAccentOrange.opacity(0.1), radius: 15, x: 0, y: 4)
                                
                                // Coins Card
                                VStack(spacing: 8) {
                                    ZStack {
                                        // Outer glow/background
                                        Circle()
                                            .fill(Color.appAccentOrange.opacity(0.2))
                                            .frame(width: 48, height: 48)
                                        
                                        // White backing for the dollar cutout
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 24, height: 24)
                                        
                                        // Icon (Circle with dollar cutout)
                                        Image(systemIcon: .dollarsignCircleFill)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.appAccentOrange)
                                    }
                                    
                                    Text(L10n.MindReader.earnings)
                                        .appTextStyle(.captionMedium, color: .appTextSecondary)
                                    
                                    Text(L10n.MindReader.earnedCoins(viewModel.earnedCoins))
                                        .appTextStyle(.headingMedium, color: .appTextHeading)
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.appSurfaceCard)
                                .cornerRadius(16)
                                .shadow(color: Color.appAccentOrange.opacity(0.1), radius: 15, x: 0, y: 4)
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
    }
}

#Preview("LightTheme") {
    MindReaderResultView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderResultView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
