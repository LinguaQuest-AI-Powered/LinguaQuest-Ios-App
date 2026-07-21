//
//  CameraTaskQuestView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.


import SwiftUI

struct CameraTaskQuestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showHintSheet: Bool = false
    @State private var showHintBubble: Bool = false
    @State private var appliedHint: String? = nil
    @State private var showNotEnoughCoinsDialog = false
    @State private var showSkipDialog = false
    @State var viewModel: CameraTaskQuestViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
       
                HStack {
                    CustomBackButton(action: { dismiss() })

                    Spacer()

                    // Coin Counter
                    RewardBadge(type: .coin, value: "\(viewModel.coins)", size: .small)
                }
                .overlay(
                    Text(L10n.Game.levelTitle(viewModel.levelId))
                        .appTextStyle(.headingLarge, color: .appTextHeading)
                )
                .padding(.horizontal, 20)
                .frame(height: 64)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.appBorderBrown),
                    alignment: .bottom
                )

                
                Spacer()
                
                // Card Container
                DialogCardContainer(
                    mascotImage: .loginBird,
                    speechBubbleText: {
                        if let hint = appliedHint {
                            return hint
                        } else if showHintBubble {
                            return L10n.Game.tapForHelp
                        } else {
                            return nil
                        }
                    }(),
                    onMascotTap: {
                        showHintSheet = true
                    }
                ) {
                    VStack(spacing: 24) {
                        // Target Word & Audio Button
                        HStack(spacing: 16) {
                            Text(viewModel.targetWord)
                                .appTextStyle(.displayLarge, color: .appTextSecondary)
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .background(Color.appSurfaceCard)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.orange, lineWidth: 2)
                                )
                                .shadow(color: Color.orange.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            Button(action: {
                                // Play audio action
                            }) {
                                Image(systemIcon: .speakerWave2Fill)
                                    .appTextStyle(.headingMediumBold, color: .appTextSecondary)
                                    .frame(width: 56, height: 56)
                                    .background(Color.appSurfaceCard)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        }
                        
                        // Instructions
                        Text(L10n.Game.scanInstruction(viewModel.targetWord.lowercased()))
                            .appTextStyle(.bodyMedium, color: .gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        
                        VStack(spacing: 16) {
                            // Primary Camera Button
                            CustomButton(
                                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                                text: L10n.Game.openCamera,
                                action: {
                                    // 1. Trigger the camera scanner here
                                    viewModel.openCamera()
                                },
                                leading: Image(systemIcon: .cameraFill)
                            )
                            
                            // Skip Button
                            OutlineButton(
                                text: L10n.Game.skip,
                                action: { showSkipDialog = true}
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Automatically show the tap for help bubble after 0.2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if !showHintBubble && appliedHint == nil {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showHintBubble = true
                    }
                }
            }
        }
        .customBottomSheet(isPresented: $showHintSheet, initialDetent: .custom(ratio: 0.7)) {
            GameHintSheet(
                coins: viewModel.coins,
                onClose: { showHintSheet = false },
                onSelectHint: {
                    hintText in
                    appliedHint = hintText
                    showHintSheet = false
                },
                onNotEnoughCoins: {
                    showHintSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showNotEnoughCoinsDialog = true
                    }
                }
            )
        }
        .appDialog(isPresented: $showNotEnoughCoinsDialog) {
            NotEnoughCoinsDialog(missingCoins: 25) { // Or pass actual missing amount
                showNotEnoughCoinsDialog = false
            }
        }
        .appDialog(isPresented: $showSkipDialog) {
            SkipDialog(
                skip: {
                    showSkipDialog = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showNotEnoughCoinsDialog = true
                    }
                },
                cancel: {
                    showSkipDialog = false
                }
            )
        }
    }
}

#Preview("LightTheme") {
    CameraTaskQuestView(viewModel: CameraTaskQuestViewModel(router: Router()))
}

#Preview("DarkTheme") {
    CameraTaskQuestView(viewModel: CameraTaskQuestViewModel(router: Router()))
        .preferredColorScheme(.dark)
}


