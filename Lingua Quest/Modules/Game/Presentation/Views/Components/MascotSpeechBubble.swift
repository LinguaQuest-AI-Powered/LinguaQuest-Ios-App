//
//  MascotSpeechBubble.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct MascotSpeechBubble: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            // Speech Bubble
            Text(L10n.Game.letsLearn)
                .appTextStyle(.caption, color: .appTextBrown) // Better contrast in both modes
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appBorderBrown, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.bottom, 24) // Lift it up relative to the bird
            
            // Bird Mascot
            Image(asset: .bird)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    MascotSpeechBubble()
        .padding()
        .background(Color.appViewBackground)
}
