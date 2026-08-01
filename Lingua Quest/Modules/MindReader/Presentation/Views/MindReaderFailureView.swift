//
//  MindReaderFailureView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderFailureView: View {
    @State var viewModel: MindReaderFailureViewModel

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
                        text: viewModel.failureReason,
                        isAnimated: true,
                        animationDelay: 0.3
                    )
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(1)

                    // Result Card
                    DialogCardContainer(
                        mascotImage: .mindBustedBird, 
                        customMascotSize: CGSize(width: 180, height: 180)
                    ) {
                        VStack(spacing: 24) {

                            // Title
                            Text(L10n.MindReader.bustedTitle)
                                .appTextStyle(
                                    .displayLarge,
                                    color: .appBrandBrownDark
                                )
                                .padding(.top, 16)

                            // MARK: - Muted Rewards Summary
                            HStack(spacing: 16) {

                                // XP Pill (Muted)
                                HStack(spacing: 8) {
                                    Image(systemIcon: .starCircleFill)
                                        .font(.system(size: 16))

                                    Text(L10n.MindReader.zeroXP)
                                        .appTextStyle(
                                            .captionBold,
                                            color: .appIconBrown
                                        )
                                }
                                .foregroundColor(.appIconBrown)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    Color.appSurfaceCardMuted.opacity(0.6)
                                )
                                .cornerRadius(12)

                                // Coins Pill (Muted)
                                HStack(spacing: 8) {
                                    Image(systemIcon: .dollarsignCircleFill)
                                        .font(.system(size: 16))

                                    Text(L10n.MindReader.zeroCoins)
                                        .appTextStyle(
                                            .captionBold,
                                            color: .appIconBrown
                                        )
                                }
                                .foregroundColor(.appIconBrown)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    Color.appSurfaceCardMuted.opacity(0.6)
                                )
                                .cornerRadius(12)

                            }
                            .padding(.horizontal, 16)

                            // MARK: - Actions
                            VStack(spacing: 12) {

                                CustomButton(
                                    type: .primary,
                                    text: L10n.MindReader.tryAgain,
                                    action: { viewModel.onTryAgainTapped() },
                                    leading: Image(
                                        systemIcon: .arrowTriangle2Circlepath
                                    ),
                                    textStyle: .bodyLargeBold
                                )

                                // Reusable Outline Button (Return to Home)
                                CustomButton(
                                    type: .outline(
                                        textColor: .appAccentTeal,
                                        borderColor: .appAccentTeal
                                    ),
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

#Preview("LightTheme") {
    MindReaderFailureView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderFailureView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
