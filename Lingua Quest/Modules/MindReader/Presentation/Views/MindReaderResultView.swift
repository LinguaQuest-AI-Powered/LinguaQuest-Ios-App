//
//  MindReaderResultView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderResultView: View {
    @State var viewModel: MindReaderResultViewModel
    
    @State private var coinBadgeCenter: CGPoint = .zero
    @State private var coinCardCenter: CGPoint = .zero
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                MindReaderHeaderView(
                    action: { viewModel.goBack() },
                    xp: viewModel.statsService.xp,
                    coins: viewModel.statsService.coins,
                    coinBadgeCenter: Binding(get: { self.coinBadgeCenter }, set: { self.coinBadgeCenter = $0 })
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
            
            ConfettiView()
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .zIndex(100)
                
            if coinCardCenter != .zero && coinBadgeCenter != .zero {
                CoinFlyAnimationView(startPoint: coinCardCenter, endPoint: coinBadgeCenter)
                    .zIndex(101)
            }
        }
        .coordinateSpace(name: "global")
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
    }
}

