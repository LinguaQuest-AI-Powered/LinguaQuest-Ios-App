//
//  ReviewRecordingDialog.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI
import AVFoundation
import Combine

class AudioPlayerController: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    
    func play(data: Data) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer?.delegate = self
                }
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Failed to play audio: \\(error)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}

struct ReviewRecordingDialog: View {
    var audioData: Data
    var audioDuration: Int
    var onDiscard: () -> Void
    var onProcess: () -> Void
    
    @StateObject private var playerController = AudioPlayerController()
    
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
                        Button(action: {
                            playerController.play(data: audioData)
                        }) {
                            Circle()
                                .fill(Color.appAccentOrange)
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: playerController.isPlaying ? "pause.fill" : "play.fill")
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
                        
                        Text(String(format: "%02d:%02d", audioDuration / 60, audioDuration % 60))
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
