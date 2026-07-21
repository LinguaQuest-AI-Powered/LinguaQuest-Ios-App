//
//  ReviewRecordingDialog.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct ReviewRecordingDialog: View {
    var onDiscard: () -> Void
    var onProcess: () -> Void
    
    var body: some View {
        ZStack {
            // Background Blur
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            DialogCardContainer(
                mascotImage: .resetPasswordBird,
                customMascotSize: CGSize(width: 180, height: 180)
            ) {
                VStack(spacing: 24) {
                    // Titles
                    VStack(spacing: 8) {
                        Text(L10n.SpeakingLab.reviewRecording)
                            .appTextStyle(.headingMedium, color: .appTextHeading)
                        
                        Text(L10n.SpeakingLab.reviewRecordingSubtitle)
                            .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    
                    // Audio Player Mock
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Circle()
                                .fill(Color.appAccentOrange)
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemIcon: .play)
                                        .foregroundColor(.white)
                                )
                        }
                        
                        // Mock Waveform
                        HStack(spacing: 4) {
                            ForEach([0.4, 0.7, 1.0, 0.6, 0.8, 1.0, 0.5, 0.9], id: \.self) { scale in
                                Capsule()
                                    .fill(Color.appAccentOrange)
                                    .frame(width: 4, height: 24 * scale)
                            }
                        }
                        
                        Spacer()
                        
                        Text("0:04")
                            .font(AppTextStyle.bodyBold.font)
                            .foregroundColor(.appTextHeading)
                    }
                    .padding(16)
                    .background(Color.appAccentOrange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Buttons
                    HStack(spacing: 16) {
                        Button(action: onDiscard) {
                            HStack(spacing: 8) {
                                Image(systemIcon: .trash)
                                Text(L10n.SpeakingLab.discard)
                            }
                            .font(AppTextStyle.bodyBold.font)
                            .foregroundColor(.appTextSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.appTextSecondary.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        Button(action: onProcess) {
                            HStack(spacing: 8) {
                                Image(systemIcon: .checkmarkCircle)
                                Text(L10n.SpeakingLab.process)
                            }
                            .font(AppTextStyle.bodyBold.font)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.appAccentOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
