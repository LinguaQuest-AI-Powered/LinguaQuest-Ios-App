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
    @Environment(Router.self) private var router
    @State private var mascotPulse = false
    @State private var unreadCount = 0
    
    var body: some View {
        HStack(spacing: 10) {
            mascotAvatar
            

            Spacer(minLength: 8)
            
            RewardBadge(type: .xp, value: starCount.formattedStatsValue(), size: .normal)
                .fixedSize(horizontal: true, vertical: false)
            RewardBadge(type: .coin, value: coinCount.formattedStatsValue(), size: .normal)
                .fixedSize(horizontal: true, vertical: false)
            
            Button(action: {
                router.push(.notifications)
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemIcon: .bell)
                        .font(.system(size: 24))
                        .foregroundColor(.appTextHeading)
                    
                    if unreadCount > 0 {
                        Circle()
                            .fill(Color.appSemanticError)
                            .frame(width: 10, height: 10)
                            .background(Circle().fill(Color.appBackgroundWarm).frame(width: 14, height: 14))
                            .offset(x: -2, y: -2)
                    }
                }
            }
            .padding(.leading, 4)
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
            
            Task {
                let useCase = Resolver.shared.resolve(GetUnreadNotificationsCountUseCaseProtocol.self)
                if case .success(let count) = await useCase.execute() {
                    unreadCount = count
                }
            }
        }
    }
    

    
    private var mascotAvatar: some View {
        ZStack {
            // Glow layer
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.35 : 0.25),
                            Color.appAccentGold.opacity(colorScheme == .dark ? 0.15 : 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
            
            // Container surface
            Circle()
                .fill(Color.appSurfaceCard)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.appBrandPrimary.opacity(0.8),
                                    Color.appAccentGold.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.08), radius: 6, x: 0, y: 3)
            
            Image(asset: .bird)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .scaleEffect(mascotPulse ? 1.05 : 0.95)
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
