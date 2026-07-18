//
//  CameraTaskQuestView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct CameraTaskQuestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showHint: Bool = false
    
    @State var viewModel: CameraTaskQuestViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appViewBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
       
                HStack {
                    CustomBackButton(action: { dismiss() })
                        .background(
                            Circle()
                                .fill(Color.appCardBackground)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                    
                    Spacer()
                    
                    Text(L10n.Game.levelTitle(viewModel.levelId))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.appTextBrown)
                    
                    Spacer()
                    
                    // Coin Counter
                    HStack(spacing: 4) {
                        // Assuming you have a coin icon or using SF Symbol for now
                        Image(systemIcon: .dollarsignCircleFill)
                            .foregroundColor(.orange)
                        Text("\(viewModel.coins)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.appTextBrown)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.appCardBackground)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Card Container
                DialogCardContainer(
                    mascotImage: .loginBird,
                    speechBubbleText: showHint ? L10n.Game.tapForHelp : nil,
                    onMascotTap: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showHint.toggle()
                        }
                    }
                ) {
                    VStack(spacing: 24) {
                        // Target Word & Audio Button
                        HStack(spacing: 16) {
                            Text(viewModel.targetWord)
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(.appTextBrown)
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .background(Color.appCardBackground)
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
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.appTextBrown)
                                    .frame(width: 56, height: 56)
                                    .background(Color.appCardBackground)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        }
                        
                        // Instructions
                        Text(L10n.Game.scanInstruction(viewModel.targetWord.lowercased()))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
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
            // Automatically show the hint after 2 seconds if the user hasn't tapped yet
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if !showHint {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showHint = true
                    }
                }
            }
        }
    }
}

#Preview {
    CameraTaskQuestView(viewModel: CameraTaskQuestViewModel())
}
