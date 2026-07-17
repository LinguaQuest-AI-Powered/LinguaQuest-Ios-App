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
    @State private var appeared = false
    @State private var pulseScale: CGFloat = 1.0
    
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
        .scaleEffect(appeared ? 1 : 0)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(
                .spring(response: 0.5, dampingFraction: 0.7)
                .delay(Double(level.id) * 0.12)
            ) {
                appeared = true
            }
        }
    }
    
    // MARK: - Completed Level
    
    private func completedNode(stars: Int) -> some View {
        VStack(spacing: -6) {
            Circle()
                .fill(Color.darkGreen)
                .frame(width: 60, height: 60)
                .overlay(
                    Text("\(level.id)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(Color.darkGreen.opacity(0.8), lineWidth: 2)
                        .scaleEffect(1.1)
                )
                .shadow(color: Color.darkGreen.opacity(0.3), radius: 6, x: 0, y: 3)
            
            StarsRatingView(stars: stars)
                .offset(y: -4)
        }
    }
    
    // MARK: - Unlocked Level (Current)
    
    private var unlockedNode: some View {
        ZStack {
            // Pulse ring animation
            Circle()
                .stroke(Color.appPrimary.opacity(0.3), lineWidth: 2)
                .frame(width: 80, height: 80)
                .scaleEffect(pulseScale)
                .opacity(2 - pulseScale)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        pulseScale = 2.0
                    }
                }
            
            // Main circle
            Circle()
                .fill(Color.appPrimary)
                .frame(width: 65, height: 65)
                .overlay(
                    Text("\(level.id)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: Color.appPrimary.opacity(0.5), radius: 10, x: 0, y: 4)
            
            // Bird + Speech bubble positioned to the right
            MascotSpeechBubble()
                .offset(x: 60, y: -100)
        }
    }
    
    // MARK: - Locked Level
    
    private var lockedNode: some View {
        Circle()
            .fill(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemIcon: .lockFill)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 18))
            )
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
    }
}

//#Preview {
//    VStack(spacing: 40) {
//        LevelNodeView(level: GameLevel(id: 1, status: .completed(stars: 3), proportionalPosition: .zero))
//        LevelNodeView(level: GameLevel(id: 3, status: .unlocked, proportionalPosition: .zero))
//        LevelNodeView(level: GameLevel(id: 4, status: .locked, proportionalPosition: .zero))
//    }
//    .padding(60)
//    .background(Color.appViewBackground)
//}
