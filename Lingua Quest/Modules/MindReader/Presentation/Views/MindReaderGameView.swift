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
                // Header
                Spacer().frame(height: 48)
                HStack {
                    CustomBackButton(action: { viewModel.goBack() })
                    Spacer()
                    HStack(spacing: 8) {
                        RewardBadge(type: .xp, value: "\(viewModel.statsService.xp)", size: .small)
                        RewardBadge(type: .coin, value: "\(viewModel.statsService.coins)", size: .small)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 64)
                
                // Progress Section
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
                
                Spacer()
                
                // Bird & Bubble Section
                VStack(spacing: 12) {
                    // Question Bubble
                    VStack(spacing: 16) {
                        Text(viewModel.questionText)
                            .font(AppTextStyle.bodyLargeBold.font)
                            .foregroundColor(.appTextHeading)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 12) {
                            Button(action: { viewModel.onTranslateTapped() }) {
                                HStack(spacing: 6) {
                                    Image(systemIcon: .globe)
                                        .font(.system(size: 14))
                                    Text(L10n.MindReader.translateLifeline)
                                        .font(AppTextStyle.captionMedium.font)
                                }
                                .foregroundColor(.appTextSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.appBackgroundWarm)
                                .clipShape(Capsule())
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
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.appSurfaceCard)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.appBorderLight, lineWidth: 1)
                            )
                    )
                    .overlay(
                        // Little arrow pointing down to the bird
                        Image(systemIcon: .arrowRight) // placeholder for bubble tail, normally drawn with path or asset
                            .font(.system(size: 24))
                            .foregroundColor(.appSurfaceCard)
                            .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 2)
                            .offset(y: 12)
                            .padding(.bottom, -24)
                        , alignment: .bottom
                    )
                    .padding(.horizontal, 40)
                    .zIndex(1)
                    
                    // Main Card with Mascot
                    DialogCardContainer(
                        mascotImage: birdImageForState,
                        customMascotSize: CGSize(width: 160, height: 160)
                    ) {
                        VStack(spacing: 12) {
                            CustomButton(type: .secendry, text: L10n.MindReader.answerYes, action: { viewModel.onAnswerTapped(L10n.MindReader.answerYes) })
                            CustomButton(type: .secendry, text: L10n.MindReader.answerNo, action: { viewModel.onAnswerTapped(L10n.MindReader.answerNo) })
                            CustomButton(type: .secendry, text: L10n.MindReader.answerSometimes, action: { viewModel.onAnswerTapped(L10n.MindReader.answerSometimes) })
                            CustomButton(type: .secendry, text: L10n.MindReader.answerProbablyNot, action: { viewModel.onAnswerTapped(L10n.MindReader.answerProbablyNot) })
                            CustomButton(type: .secendry, text: L10n.MindReader.answerDontKnow, action: { viewModel.onAnswerTapped(L10n.MindReader.answerDontKnow) })
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                    .zIndex(0)
                }
            }
            
            if viewModel.isProcessing {
                loadingOverlay
            }
        }
        .navigationBarHidden(true)
        // Disable interactions when processing
        .disabled(viewModel.isProcessing)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.appBackgroundWarm.opacity(0.95).ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Mascot in Circle
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

#Preview("LightTheme") {
    MindReaderGameView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderGameView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
