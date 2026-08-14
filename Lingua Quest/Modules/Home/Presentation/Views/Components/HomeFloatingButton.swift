//
//  HomeFloatingButton.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeFloatingButton: View {
    @Binding var showMyLanguagesSheet: Bool
    let isAnimated: Bool
    let pulseWorldButton: Bool
    
    var body: some View {
        Button(action: { showMyLanguagesSheet = true }) {
            Image(asset: .world)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.appAccentTeal, .appSemanticSuccess],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(Circle().stroke(Color.appGlowTeal.opacity(0.42), lineWidth: 2))
                .clipShape(Circle())
                .shadow(color: Color.appGlowTeal.opacity(0.24), radius: 14, x: 0, y: 6)
                .scaleEffect(pulseWorldButton ? 1.04 : 0.96)
        }
        .buttonStyle(HomeScaleButtonStyle())
        .tutorialStep(.switchLanguage)
        .padding(.trailing, 20)
        .padding(.bottom, 100)
        .offset(y: isAnimated ? 0 : 50)
        .opacity(isAnimated ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6), value: isAnimated)
    }
}
