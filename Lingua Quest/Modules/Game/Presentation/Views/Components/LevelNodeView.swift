//
//  LevelNodeView.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct LevelNodeView: View {
    let level: GameLevel
    @Environment(\.colorScheme) var colorScheme
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.5
    @State private var bounceOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            switch level.status {
            case .completed(let stars):
                completedNode(stars: stars)
                
            case .unlocked:
                unlockedNode
                
            case .locked:
                lockedNode
            }
        }
    }
    
    // MARK: - Completed Level
    
    private func completedNode(stars: Int) -> some View {
        VStack(spacing: -4) {
            ZStack {
                // Outer glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.appSemanticSuccess.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 25,
                            endRadius: 50
                        )
                    )
                    .frame(width: 80, height: 80)
                
                // Main circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appSemanticSuccess.opacity(0.8),
                                Color.appSemanticSuccess
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 58, height: 58)
                    .overlay(
                        // Shine highlight (top-left gloss)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.35), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .frame(width: 58, height: 58)
                    )
                    .overlay(
                        Text("\(level.order)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.5), Color.appSemanticSuccess.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: Color.appSemanticSuccess.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            StarsRatingView(stars: stars)
                .offset(y: -2)
        }
    }
    
    // MARK: - Unlocked Level (Current)
    
    private var unlockedNode: some View {
        ZStack {
            // Outer pulsing glow ring
            Circle()
                .fill(Color.appBrandPrimary.opacity(0.15))
                .frame(width: 90, height: 90)
                .scaleEffect(pulseScale)
                .opacity(2.0 - pulseScale)
            
            // Second pulse ring (staggered)
            Circle()
                .stroke(Color.appBrandPrimary.opacity(0.2), lineWidth: 2)
                .frame(width: 80, height: 80)
                .scaleEffect(pulseScale * 0.85)
                .opacity(2.0 - pulseScale)
            
            // Glow behind main circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.appBrandPrimary.opacity(glowOpacity), .clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 55
                    )
                )
                .frame(width: 100, height: 100)
            
            // Main circle with premium gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appBrandPrimary.opacity(0.85),
                            Color.appBrandPrimary
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 65, height: 65)
                .overlay(
                    // Gloss highlight
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), .clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: 65, height: 65)
                )
                .overlay(
                    Text("\(level.order)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.7), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3.5
                        )
                )
                .shadow(color: Color.appBrandPrimary.opacity(0.5), radius: 12, x: 0, y: 5)
                .offset(y: bounceOffset)
            
            // Mascot positioned to the right, lower down so it doesn't cover the locked node above it
            MascotSpeechBubble()
                .offset(x: 75, y: -35)
        }
        .onAppear {
            // Pulse ring animation
            withAnimation(
                .easeInOut(duration: 1.8)
                .repeatForever(autoreverses: false)
            ) {
                pulseScale = 2.0
            }
            // Glow breathing
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
            ) {
                glowOpacity = 0.8
            }
            // Gentle float/bounce
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                bounceOffset = -4
            }
        }
    }
    
    // MARK: - Locked Level
    
    private var lockedNode: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5),
                            Color.white.opacity(colorScheme == .dark ? 0.08 : 0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    // Gloss
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), .clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: 50, height: 50)
                )
                .overlay(
                    Image(systemIcon: .lockFill)
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18, weight: .semibold))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}
