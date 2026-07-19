//
//  HomeBackgroundView.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

struct HomeBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animateMagic = false
    
    var body: some View {
        ZStack {
            Image(asset: .homeBackground)
                .resizable()
                .scaledToFill()
                .clipped()
                .saturation(colorScheme == .dark ? 0.78 : 1.05)
                .brightness(colorScheme == .dark ? -0.08 : 0.02)
            
            LinearGradient(
                colors: backgroundOverlayColors,
                startPoint: .top,
                endPoint: .bottom
            )
            
            QuestMagicLayer(animateMagic: animateMagic && !reduceMotion)
                .opacity(colorScheme == .dark ? 0.65 : 0.85)
                .allowsHitTesting(false)
        }
        .background(Color.appBackgroundPrimary)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
                animateMagic = true
            }
        }
    }
    
    private var backgroundOverlayColors: [Color] {
        if colorScheme == .dark {
            return [
                Color.appSurfaceNavBar.opacity(0.72),
                Color.appBackgroundPrimary.opacity(0.54),
                Color.black.opacity(0.34)
            ]
        }
        
        return [
            Color.appBackgroundPrimary.opacity(0.36),
            Color.appGlowTeal.opacity(0.12),
            Color.appBackgroundWarm.opacity(0.24)
        ]
    }
}

private struct QuestMagicLayer: View {
    let animateMagic: Bool
    
    private let sparkles: [QuestSparkle] = [
        .init(x: 0.14, y: 0.20, size: 12, delay: 0.0),
        .init(x: 0.82, y: 0.23, size: 10, delay: 0.2),
        .init(x: 0.68, y: 0.40, size: 8, delay: 0.4),
        .init(x: 0.26, y: 0.55, size: 9, delay: 0.6),
        .init(x: 0.90, y: 0.66, size: 13, delay: 0.8),
        .init(x: 0.42, y: 0.78, size: 8, delay: 1.0)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(sparkles.enumerated()), id: \.offset) { index, sparkle in
                    Image(systemIcon: .sparkles)
                        .font(.system(size: sparkle.size, weight: .bold))
                        .foregroundColor(index.isMultiple(of: 2) ? .appGlowTeal : .appBrandPrimary)
                        .shadow(color: index.isMultiple(of: 2) ? .appGlowTeal.opacity(0.5) : .appGlowGold.opacity(0.45), radius: 10)
                        .scaleEffect(animateMagic ? 1.22 : 0.72)
                        .opacity(animateMagic ? 0.95 : 0.35)
                        .position(
                            x: geometry.size.width * sparkle.x,
                            y: geometry.size.height * sparkle.y + (animateMagic ? -12 : 12)
                        )
                        .animation(
                            .easeInOut(duration: 2.4)
                            .delay(sparkle.delay)
                            .repeatForever(autoreverses: true),
                            value: animateMagic
                        )
                }
                
                QuestPathDots(animateMagic: animateMagic)
                    .frame(width: geometry.size.width * 0.82, height: geometry.size.height * 0.58)
                    .position(x: geometry.size.width * 0.52, y: geometry.size.height * 0.58)
            }
        }
    }
}

private struct QuestPathDots: View {
    let animateMagic: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: geometry.size.width * 0.04, y: geometry.size.height * 0.76))
                path.addCurve(
                    to: CGPoint(x: geometry.size.width * 0.96, y: geometry.size.height * 0.18),
                    control1: CGPoint(x: geometry.size.width * 0.26, y: geometry.size.height * 0.22),
                    control2: CGPoint(x: geometry.size.width * 0.70, y: geometry.size.height * 0.98)
                )
            }
            .trim(from: 0.02, to: animateMagic ? 0.98 : 0.72)
            .stroke(
                Color.appGlowGold.opacity(0.22),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [3, 16])
            )
            .blur(radius: 0.3)
        }
    }
}

private struct QuestSparkle {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let delay: Double
}
