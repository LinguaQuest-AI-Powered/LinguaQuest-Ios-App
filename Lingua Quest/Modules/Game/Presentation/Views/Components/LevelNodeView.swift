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
    
    var body: some View {
        ZStack {
            switch level.status {
            case .completed(let stars):
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
                    
                    StarsRatingView(stars: stars)
                        .offset(y: -4)
                }
                
            case .unlocked:
                ZStack(alignment: .bottomTrailing) {
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
                        .shadow(color: Color.appPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    MascotSpeechBubble()
                        .offset(x: 100, y: -20)
                }
                
            case .locked:
                Circle()
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        LevelNodeView(level: GameLevel(id: 1, status: .completed(stars: 3), proportionalPosition: .zero))
        LevelNodeView(level: GameLevel(id: 3, status: .unlocked, proportionalPosition: .zero))
        LevelNodeView(level: GameLevel(id: 4, status: .locked, proportionalPosition: .zero))
    }
    .padding(60)
    .background(Color.appViewBackground)
}
