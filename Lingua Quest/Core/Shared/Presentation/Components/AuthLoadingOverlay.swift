//
//  AuthLoadingOverlay.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct AuthLoadingOverlay: ViewModifier {
    let isLoading: Bool
    @State private var isPulsing: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)

            if isLoading {
                ZStack {
                    // 1. Full-screen dimmed blurred background
                    Color.black.opacity(0.3)
                        .background(.regularMaterial)
                        .ignoresSafeArea()
                    
                    // 2. Glowing background orbs for magical effect
                    ZStack {
                        Circle()
                            .fill(Color.appAccentOrange.opacity(0.3))
                            .frame(width: 250, height: 250)
                            .blur(radius: 60)
                            .offset(x: -80, y: -80)
                            
                        Circle()
                            .fill(Color.appSemanticSuccess.opacity(0.3))
                            .frame(width: 250, height: 250)
                            .blur(radius: 60)
                            .offset(x: 80, y: 80)
                    }

                    // 3. Premium Glassmorphic Card
                    VStack(spacing: 28) {
                        ZStack {
                            // Pulsing rings
                            Circle()
                                .stroke(Color.appAccentOrange.opacity(0.6), lineWidth: 4)
                                .frame(width: 140, height: 140)
                                .scaleEffect(isPulsing ? 1.3 : 0.8)
                                .opacity(isPulsing ? 0 : 1)
                                .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: isPulsing)
                            
                            Circle()
                                .stroke(Color.appSemanticSuccess.opacity(0.4), lineWidth: 3)
                                .frame(width: 140, height: 140)
                                .scaleEffect(isPulsing ? 1.5 : 0.9)
                                .opacity(isPulsing ? 0 : 1)
                                .animation(.easeOut(duration: 1.8).delay(0.2).repeatForever(autoreverses: false), value: isPulsing)

                            // Floating Mascot
                            Image(asset: .bird)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .offset(y: isPulsing ? -6 : 6)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
                        }

                        VStack(spacing: 16) {
                            Text(L10n.Common.loading)
                                .appTextStyle(.headingLarge, color: .appTextPrimary)
                            
                            ProgressView()
                                .tint(.appAccentOrange)
                                .scaleEffect(1.2)
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.appSurfaceCard.opacity(0.95))
                            .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                    )
                    .onAppear {
                        isPulsing = true
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLoading)
                .zIndex(100)
            }
        }
    }
}

extension View {
    func authLoadingOverlay(isLoading: Bool) -> some View {
        self.modifier(AuthLoadingOverlay(isLoading: isLoading))
    }
}
