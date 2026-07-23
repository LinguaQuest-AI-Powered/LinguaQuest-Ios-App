//
//  SpeakButton.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Reusable pulsing icon button used to trigger text-to-speech on a section
struct SpeakButton: View {
    // MARK: - Properties
    let isSpeaking: Bool
    let action: () -> Void
    var size: CGFloat = 34
    var iconSize: CGFloat = 15
    
    @State private var isPulsing = false
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Image(systemIcon: isSpeaking ? .speakerWave2Fill : .speakerSlashFill)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(isSpeaking ? .white : .appAccentTeal)
                .frame(width: size, height: size)
                .background(
                    Circle().fill(isSpeaking ? Color.appSemanticSuccess : Color.appBadgeTealBg)
                )
                .scaleEffect(isSpeaking && isPulsing ? 1.18 : 1.0)
        }
        .onChange(of: isSpeaking) { _, speaking in
            if speaking {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            } else {
                isPulsing = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 16) {
        SpeakButton(isSpeaking: false, action: {})
        SpeakButton(isSpeaking: true, action: {})
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
