//
//  CameraTaskQuestView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct CameraTaskQuestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showHintSheet: Bool = false
    @State private var showHintBubble: Bool = false
    @State private var appliedHint: String? = nil
    
    @State var viewModel: CameraTaskQuestViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
       
                HStack {
                    CustomBackButton(action: { dismiss() })
                        .background(
                            Circle()
                                .fill(Color.appSurfaceCard)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                    
                    Spacer()
                    
                    Text(L10n.Game.levelTitle(viewModel.levelId))
                        .appTextStyle(.headingMediumBold, color: .appTextSecondary)
                    
                    Spacer()
                    
                    // Coin Counter
                    HStack(spacing: 4) {
                        Image(systemIcon: .dollarsignCircleFill)
                            .foregroundColor(.orange)
                        Text("\(viewModel.coins)")
                            .appTextStyle(.captionBold, color: .appTextSecondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.appSurfaceCard)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
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
                                type: .primary,
                                text: L10n.Game.openCamera,
                                action: { /* Open camera */ },
                                leading: Image(systemIcon: .cameraFill)
                            )
                            
                            // Skip Button
                            OutlineButton(
                                text: L10n.Game.skip,
                                action: { /* Skip action */ }
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
                onSelectHint: { hintText in
                    appliedHint = hintText
                    showHintSheet = false
                }
            )
        }
    }
}

#Preview("LightTheme") {
    CameraTaskQuestView(viewModel: CameraTaskQuestViewModel())
}

#Preview("DarkTheme") {
    CameraTaskQuestView(viewModel: CameraTaskQuestViewModel())
        .preferredColorScheme(.dark)
}
