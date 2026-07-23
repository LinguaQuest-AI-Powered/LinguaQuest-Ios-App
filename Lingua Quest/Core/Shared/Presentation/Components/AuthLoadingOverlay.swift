//
//  AuthLoadingOverlay.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct AuthLoadingOverlay: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let isLoading: Bool
    @State private var isPulsing: Bool = false

    // MARK: - Layout Constants (matching DialogCardContainer)
    private let cornerRadius: CGFloat = 48
    private let borderWidth: CGFloat = 2
    private let glowSize: CGFloat = 256
    private let glowBlur: CGFloat = 32
    private let glowOffset: CGFloat = 94

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)

            if isLoading {
                ZStack {
                    // Full-screen dimmed blurred background
                    Color.black.opacity(0.15)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()

                    // Premium Card (DialogCardContainer style)
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
                                .stroke(Color.appGlowTeal.opacity(0.4), lineWidth: 3)
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
                    .frame(maxWidth: .infinity)
                    .background(cardBackground)
                    .overlay(cardBorder)
                    .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 10)
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                    .padding(.horizontal, 24)
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

    // MARK: - Card Background (same as DialogCardContainer)

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.appSurfaceCard)
            .overlay {
                decorativeBackground
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                Color.appBorderCool.opacity(colorScheme == .dark ? 0.4 : 1.0),
                lineWidth: borderWidth
            )
    }

    private var decorativeBackground: some View {
        ZStack {
            Circle()
                .fill(Color.appGlowTeal.opacity(colorScheme == .dark ? 0.12 : 0.2))
                .frame(width: glowSize, height: glowSize)
                .padding(glowBlur * 2)
                .blur(radius: glowBlur)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: glowOffset, y: -glowOffset)

            Circle()
                .fill(Color.appGlowGold.opacity(colorScheme == .dark ? 0.12 : 0.2))
                .frame(width: glowSize, height: glowSize)
                .padding(glowBlur * 2)
                .blur(radius: glowBlur)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .offset(x: -glowOffset, y: glowOffset)
        }
    }
}

extension View {
    func authLoadingOverlay(isLoading: Bool) -> some View {
        self.modifier(AuthLoadingOverlay(isLoading: isLoading))
    }
}
