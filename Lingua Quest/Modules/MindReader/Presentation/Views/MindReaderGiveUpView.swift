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
                            
                            // MARK: - Simulated Dropdown List
                            VStack(spacing: 0) {
                                // Dropdown Header
                                HStack {
                                    Text(viewModel.selectedWord?.text ?? L10n.MindReader.selectWord)
                                        .appTextStyle(.bodyLargeMedium, color: viewModel.selectedWord == nil ? .appTextSecondary : .appTextHeading)
                                    Spacer()
                                    Image(systemIcon: .chevronDown)
                                        .foregroundColor(.appBrandBrownDark)
                                }
                                .padding()
                                
                                Divider()
                                    .background(Color.appSurfaceCardWarm)
                                
                                // Dropdown Options
                                ScrollView(showsIndicators: false) {
                                    VStack(spacing: 0) {
                                        ForEach(viewModel.availableWords, id: \.self) { word in
                                            Button(action: {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    viewModel.selectWord(word)
                                                }
                                            }) {
                                                HStack(spacing: 16) {
                                                    // Item Icon
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color.appAccentTeal.opacity(0.15))
                                                            .frame(width: 40, height: 40)
                                                        
                                                        Image(systemIcon: word.icon)
                                                            .font(.system(size: 16))
                                                            .foregroundColor(.appAccentTeal)
                                                    }
                                                    
                                                    Text(word.text)
                                                        .appTextStyle(.bodyLargeMedium, color: .appTextHeading)
                                                    
                                                    Spacer()
                                                    
                                                    // Selection Checkmark
                                                    if viewModel.selectedWord == word {
                                                        Image(systemIcon: .checkmark)
                                                            .foregroundColor(.appAccentTeal)
                                                            .font(.system(size: 16, weight: .bold))
                                                    }
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                                .background(viewModel.selectedWord == word ? Color.appSurfaceCardWarm.opacity(0.5) : Color.clear)
                                            }
                                            
                                            // Divider between items
                                            if word != viewModel.availableWords.last {
                                                Divider()
                                                    .background(Color.appSurfaceCardWarm)
                                            }
                                        }
                                    }
                                }
                                .frame(maxHeight: 200) // Limits list height to match Figma's scroll area
                            }
                            .background(Color.appBorderLight) // #F2DFD1 Match
                            .cornerRadius(24)
                            .padding(.horizontal, 16)
                            
                            // MARK: - Actions
                            VStack(spacing: 12) {
                                
                                CustomButton(
                                    type: .primary,
                                    text: L10n.MindReader.submit,
                                    action: { viewModel.onSubmitTapped() },
                                    status: viewModel.selectedWord == nil ? .disable : .enable,
                                    trailing: Image(systemIcon: .arrowRight), // using arrowRight to mimic send/paperplane
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
        .navigationBarHidden(true)
    }
}

#Preview("LightTheme") {
    MindReaderGiveUpView(viewModel: .preview)
}

#Preview("DarkTheme") {
    MindReaderGiveUpView(viewModel: .preview)
        .preferredColorScheme(.dark)
}
