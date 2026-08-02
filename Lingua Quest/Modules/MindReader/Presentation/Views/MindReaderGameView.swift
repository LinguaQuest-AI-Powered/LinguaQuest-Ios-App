//
//  MindReaderGameView.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import SwiftUI

struct MindReaderGameView: View {
    @State var viewModel: MindReaderGameViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                MindReaderHeaderView(
                    action: { viewModel.goBack() },
                    xp: viewModel.statsService.xp,
                    coins: viewModel.statsService.coins
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 40) {
                        // Progress Section
                        progressSection
                        
                        // Bird & Bubble Section
                        gameContentSection
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            
            if viewModel.isProcessing {
                loadingOverlay
            }
        }
        .navigationBarHidden(true)
        .disabled(viewModel.isProcessing)
        .appDialog(isPresented: $viewModel.showTranslateConfirmDialog) {
            CostActionDialog(
                title: L10n.MindReader.translateLifeline,
                subtitle: L10n.Game.skipWordSubtitle(viewModel.translateCost),
                cost: viewModel.translateCost,
                mascotImage: .mindBird,
                primaryButtonText: L10n.Common.ok,
                primaryButtonIcon: nil,
                primaryAction: { viewModel.confirmTranslation() },
                cancelAction: { viewModel.showTranslateConfirmDialog = false }
            )
        }
        .appDialog(isPresented: $viewModel.showNotEnoughCoinsDialog) {
            NotEnoughCoinsDialog(
                title: L10n.Game.notEnoughCoinsTitle,
                subtitle: L10n.Game.notEnoughCoinsSubtitle,
                missingCoins: viewModel.translateCost - viewModel.statsService.coins,
                currentCoins: viewModel.statsService.coins,
                action: { viewModel.showNotEnoughCoinsDialog = false }
            )
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(L10n.MindReader.questionProgress(current: viewModel.currentQuestionIndex, total: viewModel.totalQuestions))
                    .font(AppTextStyle.bodyLargeBold.font)
                    .foregroundColor(.appBrandBrownDark)
                
                Spacer()
                
                Text(L10n.MindReader.percentComplete(viewModel.progressPercentage))
                    .font(AppTextStyle.captionMedium.font)
                    .foregroundColor(.appTextSecondary)
            }
            
            // Progress Bar
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appSurfaceCardMuted.opacity(0.5))
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appTealGreen)
                    .frame(width: max(0, min(CGFloat(viewModel.progressPercentage) / 100.0 * (UIScreen.main.bounds.width - 40), UIScreen.main.bounds.width - 40)), height: 10)
                    .animation(.spring(), value: viewModel.progressPercentage)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Game Content
    
    private var gameContentSection: some View {
        VStack(spacing: 12) {
            // Main Card with Mascot and Answer Buttons
            DialogCardContainer(
                mascotImage: birdImageForState,
                customMascotSize: CGSize(width: 160, height: 160),
                customSpeechBubble: AnyView(questionBubble)
            ) {
                VStack(spacing: 12) {
                    CustomButton(type: .secendry, text: L10n.MindReader.answerYes, action: { viewModel.onAnswerTapped(.yes) })
                    CustomButton(type: .secendry, text: L10n.MindReader.answerNo, action: { viewModel.onAnswerTapped(.no) })
                    CustomButton(type: .secendry, text: L10n.MindReader.answerSometimes, action: { viewModel.onAnswerTapped(.sometimes) })
                    CustomButton(type: .secendry, text: L10n.MindReader.answerProbablyNot, action: { viewModel.onAnswerTapped(.probablyNot) })
                    CustomButton(type: .secendry, text: L10n.MindReader.answerDontKnow, action: { viewModel.onAnswerTapped(.unknown) })
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            .zIndex(0)
        }
    }
    
    // MARK: - Question Bubble
    
    private var questionBubble: some View {
        VStack(spacing: 16) {
            Text(viewModel.questionText)
                .font(AppTextStyle.bodyLargeBold.font)
                .foregroundColor(.appTextHeading)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            // Show translation if revealed
            if viewModel.showTranslation {
                Text(viewModel.translationText)
                    .font(AppTextStyle.bodyMedium.font)
                    .foregroundColor(.appAccentTeal)
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
            
            HStack(spacing: 12) {
                if viewModel.canTranslate {
                    Button(action: { viewModel.onTranslateTapped() }) {
                        HStack(spacing: 6) {
                            Image(systemIcon: .globe)
                                .font(.system(size: 14))
                            Text(L10n.MindReader.translateLifeline)
                                .font(AppTextStyle.captionMedium.font)
                            
                            // Coin cost badge
                            RewardBadge(type: .coin, value: viewModel.translateCostText, size: .small)
                        }
                        .foregroundColor(viewModel.showTranslation ? .appTextSecondary.opacity(0.5) : .appTextSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.appBackgroundWarm)
                        .clipShape(Capsule())
                    }
                    .disabled(viewModel.showTranslation)
                }
                
                Button(action: { viewModel.onListenTapped() }) {
                    Image(systemIcon: .speakerWave2Fill)
                        .font(.system(size: 14))
                        .foregroundColor(.appBrandBrownDark)
                        .padding(10)
                        .background(Color.appBackgroundWarm)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                .fill(Color.appSurfaceCard)
                .shadow(color: Color.appBorderBrown.opacity(0.2), radius: 6, x: 0, y: 3)
        )
        .overlay(
            SpeechBubbleShape(cornerRadius: 16, tailSize: 8)
                .stroke(Color.appBorderBrown, lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .zIndex(1)
    }
    
    // MARK: - Loading Overlay
    
    private var loadingOverlay: some View {
        ZStack {
            Color.appBackgroundWarm.opacity(0.95).ignoresSafeArea()
            
            VStack(spacing: 32) {
                Image(asset: .thinkingHardBird)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .padding(16)
                    .background(Color.appSurfaceCard)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 6)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                
                Text(L10n.MindReader.thinkingHard)
                    .appTextStyle(.displayMedium, color: .appBrandBrownDark)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 48)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.appSurfaceCard)
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(Color.appGlowTeal.opacity(0.15))
                                .frame(width: 256, height: 256)
                                .blur(radius: 32)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .offset(x: 94, y: -94)

                            Circle()
                                .fill(Color.appGlowGold.opacity(0.15))
                                .frame(width: 256, height: 256)
                                .blur(radius: 32)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                .offset(x: -94, y: 94)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.appBorderCool.opacity(0.4), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, y: 10)
            .padding(.horizontal, 40)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .zIndex(100)
    }
    
    private var birdImageForState: Image.Asset {
        switch viewModel.birdState {
        case .normal: return .mindThinkingBird
        case .thinking: return .mindBubbleBird
        case .pointing: return .mindSuccessBird
        }
    }
}

