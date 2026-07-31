//
//  MindReaderIntroView.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import SwiftUI

struct MindReaderIntroView: View {
    @State var viewModel: MindReaderIntroViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
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
                
                Spacer()
                
                // Main Card
                DialogCardContainer(
                    mascotImage: .mindBird,
                    speechBubbleText: L10n.MindReader.lobbyPrompt
                ) {
                    VStack(spacing: 24) {
                        Text(L10n.MindReader.title)
                            .font(AppTextStyle.displayMedium.font)
                            .foregroundColor(.appTextHeading)
                            .multilineTextAlignment(.center)
                        
                        Text(L10n.MindReader.subtitle)
                            .font(AppTextStyle.bodyLarge.font)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        // Category Box
                        HStack(spacing: 16) {
                            Image(asset: .kitchenLogo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.appAccentOrange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.MindReader.currentCategory)
                                    .font(AppTextStyle.micro.font)
                                    .foregroundColor(.appTextSecondary)
                                Text(viewModel.currentCategoryName)
                                    .font(AppTextStyle.bodyLargeBold.font)
                                    .foregroundColor(.appTextHeading)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.appAccentOrange.opacity(0.1))
                        .cornerRadius(16)
                        
                        VStack(spacing: 16) {
                            CustomButton(
                                type: .primary,
                                text: L10n.MindReader.startGame,
                                action: { viewModel.onStartGameTapped() },
                                trailing: Image(systemIcon: .boltFill)
                            )
                            
                            CustomButton(
                                type: .secendry,
                                text: L10n.MindReader.change,
                                action: { viewModel.onChangeCategoryTapped() }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .appDialog(isPresented: $viewModel.showReadyDialog) {
            DialogCardContainer(mascotImage: .mindBird) {
                VStack(spacing: 24) {
                    Text(L10n.MindReader.confirmationQuestion)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(.appTextHeading)
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.MindReader.makeSureFitsWorld(viewModel.currentCategoryName))
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        CustomButton(
                            type: .secendry,
                            text: L10n.MindReader.notYet,
                            action: { viewModel.onNotYetTapped() }
                        )
                        
                        CustomButton(
                            type: .primary,
                            text: L10n.MindReader.yesLetsGo,
                            action: { viewModel.onYesLetsGoTapped() }
                        )
                    }
                }
            }
        }
    }
}

#Preview("LightTheme") {
    MindReaderIntroView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderIntroView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
