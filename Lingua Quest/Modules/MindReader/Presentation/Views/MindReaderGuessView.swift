//
//  MindReaderGuessView.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import SwiftUI

struct MindReaderGuessView: View {
    @State var viewModel: MindReaderGuessViewModel
    
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
                
                // Main Guess Card
                DialogCardContainer(
                    mascotImage: .guessBird,
                    customMascotSize: CGSize(width: 180, height: 180)
                ) {
                    VStack(spacing: 24) {
                        Text(L10n.MindReader.guessThinkIts)
                            .dialogTitleStyle()
                            .padding(.top, 16)
                        
                        HStack(spacing: 12) {
                            Text(viewModel.guessedWord)
                                .dialogTitleStyle()
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color.appSurfaceCardMuted)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.appBrandPrimary, lineWidth: 2)
                                )
                                .cornerRadius(16)
                            
                            Button(action: { viewModel.onListenTapped() }) {
                                Image(systemIcon: .speakerWave2Fill)
                                    .font(.system(size: 16))
                                    .foregroundColor(.appBrandBrownDark)
                                    .frame(width: 48, height: 48)
                                    .background(Color.appSurfaceCardMuted)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text(viewModel.guessedEmoji)
                            .font(.system(size: 80))
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                            .padding(.bottom, 24)
                        
                        Text(L10n.MindReader.confirmationQuestion)
                            .dialogSubtitleStyle()
                        
                        HStack(spacing: 12) {
                            CustomButton(
                                type: .secendry,
                                text: L10n.MindReader.guessNoWrong,
                                action: { viewModel.onNoWrongTapped() },
                                leading: Image(systemIcon: .xmark),
                                textStyle: .microHeavy
                            )
                            
                            CustomButton(
                                type: .primary,
                                text: L10n.MindReader.guessYesGotIt,
                                action: { viewModel.onYesGotItTapped() },
                                leading: Image(systemIcon: .checkmark),
                                textStyle: .microHeavy
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut, value: viewModel.isLoading)
    }
    
    // MARK: - Loading Overlay
    
    private var loadingOverlay: some View {
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

