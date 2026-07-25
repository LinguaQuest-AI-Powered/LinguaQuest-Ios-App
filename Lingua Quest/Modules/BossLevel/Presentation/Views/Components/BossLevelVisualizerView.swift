//
//  BossLevelVisualizerView.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI

struct BossLevelVisualizerView: View {
    let isAISpeaking: Bool
    let isUserSpeaking: Bool
    let aiAudioLevel: Float
    let userAudioLevel: Float
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Pulsing Halo Outer Rings
                Circle()
                    .fill(Color.appGlowTeal.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .scaleEffect(isAISpeaking ? pulseScale * (1.0 + CGFloat(aiAudioLevel) * 0.4) : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseScale)
                
                Circle()
                    .fill(Color.appBrandPrimary.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isUserSpeaking ? (1.0 + CGFloat(userAudioLevel) * 0.5) : 1.0)
                
                // Mascot Circle Container
                Circle()
                    .fill(Color.appHeaderBirdCircleBg)
                    .frame(width: 110, height: 110)
                    .overlay(
                        Circle()
                            .stroke(isAISpeaking ? Color.appGlowTeal : Color.appBrandBrown, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                // Lingo Mascot Icon / Symbol
                Image(systemName: "bird.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .foregroundColor(Color.appBrandBrownDark)
                    .scaleEffect(isAISpeaking ? 1.08 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isAISpeaking)
            }
            .onAppear {
                pulseScale = 1.2
            }
            
            // Audio Waveform Bar Visualizer
            HStack(spacing: 5) {
                ForEach(0..<12, id: \.self) { index in
                    let level = isAISpeaking ? aiAudioLevel : (isUserSpeaking ? userAudioLevel : 0.05)
                    // Use a deterministic multiplier per bar index instead of random
                    let multipliers: [Float] = [0.6, 0.9, 0.7, 1.0, 0.8, 0.5, 1.0, 0.75, 0.9, 0.55, 0.85, 0.65]
                    let barHeight = max(8, CGFloat(level) * 60.0 * CGFloat(multipliers[index]))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(isAISpeaking ? Color.appGlowTeal : (isUserSpeaking ? Color.appBrandPrimary : Color.appSurfaceCardMuted))
                        .frame(width: 5, height: barHeight)
                        .animation(.spring(response: 0.15, dampingFraction: 0.6), value: barHeight)
                }
            }
            .frame(height: 64)
            .padding(.horizontal, 24)
            .background(Color.appSurfaceCard.opacity(0.6))
            .cornerRadius(16)
        }
    }
}
