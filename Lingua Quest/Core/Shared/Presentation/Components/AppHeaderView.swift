//
//  AppHeaderView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct AppHeaderView: View {
    var starCount: Int
    var coinCount: Int
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var mascotPulse = false
    
    var body: some View {
        HStack(spacing: 10) {
            mascotAvatar
            
            Text(L10n.Components.appName)
                .appTextStyle(.bodyLargeBold, color: .appBrandBrown)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Spacer(minLength: 8)
            
            RewardBadge(type: .xp, value: formatValue(starCount), size: .normal)
                .frame(minWidth: 88)
            RewardBadge(type: .coin, value: formatValue(coinCount), size: .normal)
                .frame(minWidth: 88)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 14)
        .background(headerBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appGlowTeal.opacity(colorScheme == .dark ? 0.28 : 0.35),
                            Color.appBrandPrimary.opacity(0.18)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .opacity(colorScheme == .dark ? 0 : 1)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.7).repeatForever(autoreverses: true)) {
                mascotPulse = true
            }
        }
    }
    
    private func formatValue(_ value: Int) -> String {
        if value >= 1_000_000 {
            let formatted = String(format: "%.1fM", Double(value) / 1_000_000)
            return formatted.replacingOccurrences(of: ".0M", with: "M")
        } else if value >= 10_000 {
            let formatted = String(format: "%.1fK", Double(value) / 1_000)
            return formatted.replacingOccurrences(of: ".0K", with: "K")
        } else {
            return "\(value)"
        }
    }
    
    private var mascotAvatar: some View {
        ZStack {
            Circle()
                .fill(Color.appHeaderBirdCircleBg)
                .frame(width: 52, height: 52)
                .shadow(color: Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.22 : 0.3), radius: 12, x: 0, y: 6)
            
            Circle()
                .stroke(Color.appSurfaceCard.opacity(0.9), lineWidth: 3)
                .frame(width: 52, height: 52)
            
            Image(asset: .appBarBird)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .scaleEffect(mascotPulse ? 1.05 : 0.96)
                .rotationEffect(.degrees(mascotPulse ? 2 : -2))
        }
    }
    
    private var headerBackground: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 26,
                bottomTrailingRadius: 26,
                topTrailingRadius: 0,
                style: .continuous
            )
            .fill(.ultraThinMaterial)
            
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 26,
                bottomTrailingRadius: 26,
                topTrailingRadius: 0,
                style: .continuous
            )
            .fill(Color.appSurfaceNavBar.opacity(colorScheme == .dark ? 0.76 : 0.88))
        }
        .ignoresSafeArea(edges: .top)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.22 : 0.08), radius: 16, x: 0, y: 10)
    }
}
