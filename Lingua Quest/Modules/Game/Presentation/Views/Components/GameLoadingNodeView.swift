//
//  GameLoadingNodeView.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import SwiftUI

struct GameLoadingNodeView: View {
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Glowing aura that expands and fades
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 80, height: 80)
                .blur(radius: isAnimating ? 12 : 4)
                .scaleEffect(isAnimating ? 1.4 : 0.8)
            
            // Main bouncing circle (looks like a game coin or token)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color.white.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            // Premium Magical Icon
            ZStack {
                // Spinning dashed energy ring
                Circle()
                    .strokeBorder(
                        LinearGradient(colors: [Color.white.opacity(0.8), .clear, Color.white.opacity(0.3)], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                    )
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 4.0).repeatForever(autoreverses: false), value: isAnimating)
                
                // Glowing Custom Star Asset
                Image(asset: .star)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .shadow(color: .yellow.opacity(0.6), radius: 4, x: 0, y: 0)
                    .scaleEffect(isAnimating ? 1.1 : 0.85)
                
                // Little twinkling sparkle
                Image(systemIcon: .sparkles)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: 14, y: -14)
                    .opacity(isAnimating ? 1 : 0.2)
                    .scaleEffect(isAnimating ? 1.3 : 0.6)
            }
        }
        // Make the entire node bounce up and down
        .offset(y: isAnimating ? -12 : 4)
        .onAppear {
            // Stagger the animation so they bounce in a wave along the road!
            let delay = Double(index) * 0.15
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(delay)) {
                isAnimating = true
            }
        }
    }
}


