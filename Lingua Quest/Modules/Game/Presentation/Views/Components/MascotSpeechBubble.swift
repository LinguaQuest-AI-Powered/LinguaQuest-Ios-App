//
//  MascotSpeechBubble.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct MascotSpeechBubble: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var bubbleScale: CGFloat = 0
    @State private var birdOffset: CGFloat = 20
    @State private var birdOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: -10) {
            // Speech Bubble above the bird's head/beak
            Text(L10n.Game.letsLearn)
                .appTextStyle(.caption, color: .appTextBrown)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appBorderBrown, lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .scaleEffect(bubbleScale)
            
            // Bird Mascot
            Image(asset: .bird)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: birdOffset)
                .opacity(birdOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                birdOffset = 0
                birdOpacity = 1
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.7)) {
                bubbleScale = 1
            }
        }
    }
}

#Preview {
    MascotSpeechBubble()
        .padding()
        .background(Color.appViewBackground)
}
