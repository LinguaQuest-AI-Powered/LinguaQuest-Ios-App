//
//  ObjectDetectionCardView.swift
//  Lingua Quest
//
//  Created by siam on 06/08/2026.
//

import SwiftUI

struct ObjectDetectionCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let worldName: String?
    let targetWord: String?
    let levelOrder: Int
    let totalLevels: Int
    var isLoading: Bool = false
    var action: () -> Void
    
    @State private var mascotBounce = false
    @State private var plateRotation: Double = 0
    @State private var plateScale: CGFloat = 0.85
    @State private var shimmerOffset: CGFloat = -200
    @State private var pulseRing = false
    @State private var buttonGlow = false
    
    private var isEmptyState: Bool {
        worldName == nil
    }
    
    private var displayWorldName: String {
        isEmptyState ? L10n.Home.exploreWorlds : (worldName ?? L10n.Home.objectDetectionTitle)
    }
    
    private var displayWord: String {
        targetWord ?? "..."
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 18)
                    .padding(.horizontal, 18)
                
                centerSection
                    .padding(.top, 12)
                    .padding(.bottom, 14)
                
                Spacer(minLength: 0)
                
                continueButton
                    .padding(.horizontal, 18)
                    .padding(.bottom, 18)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(cardBorder)
            .shadow(
                color: Color.appSemanticSuccess.opacity(colorScheme == .dark ? 0.12 : 0.08),
                radius: 20, x: 0, y: 10
            )
        }
        .buttonStyle(HomeScaleButtonStyle())
        .disabled(isLoading)
        .onAppear { startAnimations() }
    }
}

// MARK: - Header Section
private extension ObjectDetectionCardView {
    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Home.currentQuest)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appProgressBar)
                
                Text(displayWorldName)
                    .font(AppTextStyle.headingMediumBold.font)
                    .foregroundColor(.appTextHeading)
                    .lineLimit(1)
                    .id(displayWorldName)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: displayWorldName)
                
                Text(isEmptyState ? L10n.Worlds.allWorldsSubtitle : L10n.Home.findAndCapture)
                    .font(AppTextStyle.bodyMedium.font)
                    .foregroundColor(.appTextSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if !isEmptyState {
                progressBadge
            } else {
                startBadge
            }
        }
    }
    
    var progressBadge: some View {
        Text(L10n.Home.levelProgress(current: levelOrder, total: totalLevels))
            .font(AppTextStyle.microBold.font)
            .foregroundColor(.appTextSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .id(levelOrder)
            .transition(.opacity.combined(with: .scale(scale: 0.8)))
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: levelOrder)
            .background(
                Capsule()
                    .fill(Color.appSurfaceCardWarm)
            )
            .overlay(
                Capsule()
                    .stroke(Color.appBorderBrown, lineWidth: 1)
            )
    }

    var startBadge: some View {
        HStack(spacing: 4) {
            Image(systemIcon: .sparkles)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.appAccentOrange)
            Text(L10n.Home.start)
                .font(AppTextStyle.microBold.font)
                .foregroundColor(.appAccentOrange)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.appAccentOrange.opacity(0.15))
        )
        .overlay(
            Capsule()
                .stroke(Color.appAccentOrange.opacity(0.4), lineWidth: 1)
        )
    }
}

// MARK: - Center Section (Mascot + Word Plate)
private extension ObjectDetectionCardView {
    var centerSection: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 8)
            
            mascotView
            
            Spacer(minLength: 12)
            
            wordPlateView
                .frame(width: 140, height: 140)
            
            Spacer(minLength: 8)
        }
        .frame(maxWidth: .infinity)
    }
    
    var mascotView: some View {
        Image(asset: .heroCard)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .offset(y: mascotBounce ? -6 : 4)
            .shadow(
                color: Color.appSemanticSuccess.opacity(0.15),
                radius: 8, x: 0, y: 6
            )
    }
    
    var wordPlateView: some View {
        ZStack {
            if isEmptyState {
                // Outer pulsing aura
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.appGlowTeal.opacity(0.35), Color.clear],
                            center: .center,
                            startRadius: 15,
                            endRadius: 70
                        )
                    )
                    .scaleEffect(pulseRing ? 1.12 : 0.95)
                
                // Plate outer ring with rich gradient border
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [.appAccentTeal, .appSemanticSuccess, .appGlowTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appSurfaceCardWarm, Color.appSurfaceCard],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .frame(width: 125, height: 125)
                    .shadow(color: Color.appGlowTeal.opacity(0.25), radius: 10, x: 0, y: 5)
                
                // Rich 3D World Asset Graphic
                Image(asset: .world)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .scaleEffect(pulseRing ? 1.05 : 0.96)
                
                // Floating Sparkle Badge at top right
                Image(systemIcon: .sparkles)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.appAccentOrange)
                    .padding(6)
                    .background(Circle().fill(Color.appSurfaceCardWarm))
                    .overlay(Circle().stroke(Color.appAccentOrange.opacity(0.5), lineWidth: 1.5))
                    .shadow(color: Color.appAccentOrange.opacity(0.3), radius: 5, x: 0, y: 2)
                    .offset(x: 42, y: -40)
            } else {
                // Outer glow ring
                Circle()
                    .stroke(
                        Color.appProgressBar.opacity(pulseRing ? 0.25 : 0.08),
                        lineWidth: 3
                    )
                    .frame(width: 154, height: 154)
                    .scaleEffect(pulseRing ? 1.08 : 1.0)
                
                // Plate outer ring
                Circle()
                    .strokeBorder(
                        Color.appProgressBar,
                        lineWidth: 18
                    )
                    .background(Circle().fill(Color.appSurfaceCardWarm))
                    .frame(width: 140, height: 140)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 6, x: 0, y: 3
                    )
                
                // Plate inner styling
                Circle()
                    .stroke(Color.appBorderBrown.opacity(0.2), lineWidth: 1)
                    .frame(width: 104, height: 104)
                
                // Word text
                Text(displayWord)
                    .font(AppTextStyle.bodyBold.font)
                    .foregroundColor(.appProgressBar)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.45)
                    .frame(maxWidth: 90)
                    .padding(.horizontal, 4)
                    .id(displayWord)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: displayWord)
            }
        }
        .scaleEffect(plateScale)
        .rotationEffect(.degrees(plateRotation))
    }
}

// MARK: - Continue Button
private extension ObjectDetectionCardView {
    var continueButton: some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Image(systemIcon: isEmptyState ? .play : .camera)
                    .font(.system(size: 16, weight: .bold))
                
                Text(isEmptyState ? L10n.Home.start : L10n.Home.continueButton)
                    .font(AppTextStyle.bodyLargeBold.font)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(
            ZStack {
                Capsule()
                    .fill(Color.appAccentOrange)
                
                // Shimmer effect
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.2),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset)
                    .mask(Capsule())
            }
        )
        .clipShape(Capsule())
        .shadow(
            color: Color.appAccentOrange.opacity(buttonGlow ? 0.45 : 0.2),
            radius: buttonGlow ? 14 : 8,
            x: 0, y: 4
        )
    }
}

// MARK: - Card Background & Border
private extension ObjectDetectionCardView {
    var cardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.95 : 0.98))
            
            // Subtle decorative gradient at top-right
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appGlowTeal.opacity(colorScheme == .dark ? 0.04 : 0.06),
                            Color.clear
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
        }
    }
    
    var cardBorder: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.appSemanticSuccess.opacity(0.3),
                        Color.appBorderLight.opacity(colorScheme == .dark ? 0.5 : 0.7),
                        Color.appGlowTeal.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.5
            )
    }
}

// MARK: - Animations
private extension ObjectDetectionCardView {
    func startAnimations() {
        guard !reduceMotion else { return }
        
        // Mascot floating bounce
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            mascotBounce = true
        }
        
        // Plate entrance
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
            plateScale = 1.0
        }
        
        // Subtle plate wobble
        withAnimation(
            .easeInOut(duration: 3.5)
            .repeatForever(autoreverses: true)
            .delay(0.5)
        ) {
            plateRotation = 3
        }
        
        // Pulse ring
        withAnimation(
            .easeInOut(duration: 1.8)
            .repeatForever(autoreverses: true)
        ) {
            pulseRing = true
        }
        
        // Button glow pulse
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
            .delay(0.3)
        ) {
            buttonGlow = true
        }
        
        // Shimmer sweep
        startShimmer()
    }
    
    func startShimmer() {
        withAnimation(
            .linear(duration: 2.0)
            .repeatForever(autoreverses: false)
            .delay(1.0)
        ) {
            shimmerOffset = 400
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundPrimary.ignoresSafeArea()
        ObjectDetectionCardView(
            worldName: "Kitchen World",
            targetWord: "la taza",
            levelOrder: 4,
            totalLevels: 10,
            action: {}
        )
        .padding(.horizontal, 20)
    }
}
