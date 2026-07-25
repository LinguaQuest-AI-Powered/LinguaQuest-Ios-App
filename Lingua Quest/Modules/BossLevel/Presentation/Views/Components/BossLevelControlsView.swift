//
//  BossLevelControlsView.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI

struct BossLevelControlsView: View {
    let isHoldingMic: Bool
    let isAISpeaking: Bool
    let onMicPress: () -> Void
    let onMicRelease: () -> Void
    let onEndCall: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Hold-to-Talk mic button
            micButton

            // End phase pill button
            endCallButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }

    // MARK: - Mic Button

    private var micButton: some View {
        VStack(spacing: 12) {
            ZStack {
                // Outer pulse ring — visible only while holding
                if isHoldingMic {
                    Circle()
                        .stroke(Color.appAccentOrange.opacity(0.35), lineWidth: 6)
                        .frame(width: 96, height: 96)
                        .scaleEffect(isHoldingMic ? 1.18 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                   value: isHoldingMic)
                }

                Circle()
                    .fill(isHoldingMic ? Color.appAccentOrange.opacity(0.8) : Color.appAccentOrange)
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: Color.appAccentOrange.opacity(0.4),
                        radius: 8, x: 0, y: 4
                    )

                Image(systemName: isHoldingMic ? "mic.fill" : "mic.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(isHoldingMic ? .white : Color.appTextSecondary.opacity(0.7))
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHoldingMic)

            Text(isHoldingMic ? L10n.BossLevel.releaseToSend : L10n.BossLevel.tapToTalk)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
                .animation(.easeInOut(duration: 0.15), value: isHoldingMic)
        }
        // DragGesture(minimumDistance: 0) fires onChanged on press-down
        // and onEnded on release — reliable on both simulator and device.
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHoldingMic { onMicPress() }
                }
                .onEnded { _ in
                    if isHoldingMic { onMicRelease() }
                }
        )
        // Disable while AI is speaking so the user can't interrupt mid-playback.
        .opacity(isAISpeaking ? 0.4 : 1.0)
        .allowsHitTesting(!isAISpeaking)
    }

    // MARK: - End Call Button

    private var endCallButton: some View {
        Button(action: onEndCall) {
            Text(L10n.BossLevel.endPhase)
                .appTextStyle(.bodyBold, color: .white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.appAccentRed)
                .cornerRadius(26)
        }
    }
}
