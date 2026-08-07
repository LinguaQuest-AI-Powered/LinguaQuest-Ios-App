

import SwiftUI

struct BossLevelControlsView: View {
    let isHoldingMic: Bool
    let isAISpeaking: Bool
    let onMicPress: () -> Void
    let onMicRelease: () -> Void
    let onEndCall: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            
            micButton

            endCallButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Mic Button

    private var micButton: some View {
        VStack(spacing: 12) {
            ZStack {
               
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

                Image(systemIcon: .micFill)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(isHoldingMic ? .appTextOnPrimary : Color.appTextSecondary.opacity(0.7))
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHoldingMic)

            Text(isHoldingMic ? L10n.BossLevel.releaseToSend : L10n.BossLevel.tapToTalk)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
                .animation(.easeInOut(duration: 0.15), value: isHoldingMic)
        }
        
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHoldingMic { onMicPress() }
                }
                .onEnded { _ in
                    if isHoldingMic { onMicRelease() }
                }
        )
        
        .opacity(isAISpeaking ? 0.4 : 1.0)
        .allowsHitTesting(!isAISpeaking)
    }

    // MARK: - End Call Button

    private var endCallButton: some View {
        CustomButton(
            type: .primary,
            text: L10n.BossLevel.finishStage,
            action: onEndCall,
            status: .enable
        )
    }
}
