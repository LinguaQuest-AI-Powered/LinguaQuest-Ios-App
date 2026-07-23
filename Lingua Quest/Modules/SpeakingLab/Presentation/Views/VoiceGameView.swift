//
//  VoiceGameView.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI

struct VoiceGameView: View {
    @State var viewModel: VoiceGameViewModel
    @Environment(\.dismiss) private var dismiss
    
    // For gesture
    @State private var isPressing = false
    @State private var showSkipDialog = false
    @State private var showNotEnoughCoinsDialog = false
    
    private var isMicLocked: Bool {
        viewModel.isLoadingSentences || viewModel.isPlayingAudio || viewModel.isLoadingResult
    }
    
    private var isListenLocked: Bool {
        viewModel.recordingState != .idle || viewModel.isLoadingSentences || viewModel.isLoadingResult || viewModel.isPlayingAudio
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    CustomBackButton(action: { dismiss() })
                    
                    Spacer()
                    
                    // Coin Counter (mock value)
                    RewardBadge(type: .coin, value: "1,200", size: .small)
                }
                .overlay(
                    Text(L10n.SpeakingLab.voicePractice)
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
                
                if viewModel.isLoadingSentences {
                    // Loading state
                    DialogCardContainer(
                        mascotImage: .bird3,
                        speechBubbleText: L10n.SpeakingLab.youCanDoIt
                    ) {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(Color.appAccentOrange)
                            
                            Text(L10n.SpeakingLab.loadingSentences)
                                .appTextStyle(.bodyMedium, color: .appTextSecondary)
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.appSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                } else if let error = viewModel.loadError {
                    // Error state
                    DialogCardContainer(
                        mascotImage: .weakPasswordBird,
                        speechBubbleText: L10n.SpeakingLab.feedbackNeedsWork
                    ) {
                        VStack(spacing: 16) {
                            Text(L10n.SpeakingLab.failedToLoad)
                                .appTextStyle(.headingMedium, color: .appTextHeading)
                            
                            Text(error)
                                .appTextStyle(.bodyMedium, color: .appTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                            
                            CustomButton(
                                type: .primary,
                                text: L10n.SpeakingLab.retry,
                                action: { viewModel.retrySentences() }
                            )
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.appSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                } else {
                    // Main Content Card
                    DialogCardContainer(
                        mascotImage: viewModel.recordingState == .idle ? .bird3 : .micBird,
                        speechBubbleText: viewModel.recordingState == .idle ? L10n.SpeakingLab.youCanDoIt : L10n.SpeakingLab.listening,
                        onMascotTap: {
                            // Optional mascot tap
                        }
                    ) {
                        VStack(spacing: 24) {
                            // Top Label
                            Text(L10n.SpeakingLab.pronounceThis)
                                .font(AppTextStyle.captionBold.font)
                                .foregroundColor(Color.appTextSecondary)
                                .textCase(.uppercase)
                            
                            // Target Word
                            Text(viewModel.targetSentence)
                                .appTextStyle(.headingLarge, color: .appTextHeading)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .minimumScaleFactor(0.8)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Listen Button
                            Button(action: {
                                viewModel.playTargetSentence()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemIcon: .speakerWave2Fill)
                                    Text(L10n.SpeakingLab.listen)
                                        .font(AppTextStyle.bodyBold.font)
                                }
                                .foregroundColor(isListenLocked ? Color.appTextSecondary.opacity(0.4) : Color.appTextSecondary)
                            }
                            .disabled(isListenLocked)
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.appSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                }
                
                Spacer()
                
                // Bottom Controls
                VStack(spacing: 24) {
                    ZStack {
                        if viewModel.recordingState == .idle {
                            Text(L10n.SpeakingLab.tapAndHoldToRecord)
                                .appTextStyle(.bodyMedium, color: .appTextSecondary)
                        } else {
                            // The Timer Pill
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                
                                Text(String(format: "%02d:%02d", viewModel.recordingDuration / 60, viewModel.recordingDuration % 60))
                                    .font(AppTextStyle.bodyBold.font)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.red.opacity(0.2))
                            )
                        }
                    }
                    .frame(height: 36)
                    
                    // Big Mic / Pause Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            viewModel.toggleRecording()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(isMicLocked ? Color.gray.opacity(0.3) : (viewModel.recordingState == .recording ? Color.red : Color.appAccentOrange))
                                .frame(width: 96, height: 96)
                                .shadow(color: isMicLocked ? .clear : (viewModel.recordingState == .recording ? Color.red.opacity(0.3) : Color.appBrandBrown), radius: 0, x: 0, y: isMicLocked ? 0 : 6)
                                .scaleEffect(viewModel.recordingState == .recording ? 1.1 : 1.0)
                            
                            Image(systemIcon: viewModel.recordingState == .recording ? .pauseFill : .micFill)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(isMicLocked ? Color.gray : (viewModel.recordingState == .recording ? .white : Color.appTextSelectedBrown))
                                .scaleEffect(viewModel.recordingState == .recording ? 1.2 : 1.0)
                        }
                    }
                    .disabled(isMicLocked)
                    
                    // Skip Button
                    OutlineButton(
                        text: L10n.Game.skip,
                        action: { showSkipDialog = true }
                    )
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
            
            if viewModel.showReviewDialog, let fileURL = viewModel.recordingFileURL {
                ReviewRecordingDialog(
                    recordingURL: fileURL,
                    audioDuration: viewModel.recordingDuration,
                    onDiscard: {
                        withAnimation {
                            viewModel.discardRecording()
                        }
                    },
                    onProcess: {
                        viewModel.processRecording()
                    }
                )
            }
        }
        .navigationBarHidden(true)
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
        .appDialog(isPresented: $showNotEnoughCoinsDialog) {
            NotEnoughCoinsDialog(missingCoins: 25) {
                showNotEnoughCoinsDialog = false
            }
        }
        .onAppear {
            viewModel.resetForRetry()
        }
    }
}
