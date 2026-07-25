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
        HStack(spacing: 32) {
            // Hold-to-Talk mic button
            micButton

            // End call button
            endCallButton
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.appSurfaceCard.opacity(0.8))
        .cornerRadius(32)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.appBorderCool, lineWidth: 1)
        )
    }

    // MARK: - Mic Button

    private var micButton: some View {
        VStack(spacing: 6) {
            ZStack {
                // Outer pulse ring — visible only while holding
                if isHoldingMic {
                    Circle()
                        .stroke(Color.appBrandPrimary.opacity(0.35), lineWidth: 6)
                        .frame(width: 72, height: 72)
                        .scaleEffect(isHoldingMic ? 1.18 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                   value: isHoldingMic)
                }

                Circle()
                    .fill(isHoldingMic ? Color.appBrandPrimary : Color.appSurfaceCard)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(
                                isHoldingMic ? Color.appBrandPrimary : Color.appBorderCool,
                                lineWidth: 1.5
                            )
                    )
                    .shadow(
                        color: isHoldingMic ? Color.appBrandPrimary.opacity(0.4) : .clear,
                        radius: 8, x: 0, y: 4
                    )

                Image(systemName: isHoldingMic ? "mic.fill" : "mic")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isHoldingMic ? .white : Color.appBrandPrimary)
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHoldingMic)

            Text(isHoldingMic ? L10n.BossLevel.releaseToSend : L10n.BossLevel.holdToSpeak)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(isHoldingMic ? Color.appBrandPrimary : Color.appTextSecondary)
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
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color.appAccentRed)
                        .frame(width: 64, height: 64)
                        .shadow(color: Color.appAccentRed.opacity(0.3), radius: 8, x: 0, y: 4)
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                Text(L10n.BossLevel.endSession)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appAccentRed)
            }
        }
    }
}
