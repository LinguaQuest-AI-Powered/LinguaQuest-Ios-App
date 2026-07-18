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
    @State private var birdBounce: CGFloat = 0
    @State private var bubbleFloat: CGFloat = 0
    
    var body: some View {
        VStack(spacing: -10) {
            // Speech Bubble above the bird's head/beak
            SpeechBubbleView(text: L10n.Game.letsLearn, isAnimated: true, animationDelay: 1.0)
                .scaleEffect(bubbleScale)
                .offset(y: bubbleFloat)
            
            // Bird Mascot
            Image(asset: .bird)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: birdOffset + birdBounce)
                .opacity(birdOpacity)
        }
        .onAppear {
            // Bird flies in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.3)) {
                birdOffset = 0
                birdOpacity = 1
            }
            // Bubble pops in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.7)) {
                bubbleScale = 1
            }
            // Bird idle bounce (continuous)
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(1.0)
            ) {
                birdBounce = -6
            }
            // Bubble gentle float (continuous)
            withAnimation(
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
                .delay(1.2)
            ) {
                bubbleFloat = -4
            }
        }
    }
}

#Preview {
    MascotSpeechBubble()
        .padding()
        .background(Color.appBackgroundWarm)
}
