//
//  BossLevelEveleuationView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 26/07/2026.
//

import SwiftUI

struct BossLevelEvaluatingView: View {
    @State private var isSpinning = false
    @State private var animateContent = false

    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                DialogCardContainer(
                    showMascot: true,
                    mascotImage: .loadingBird,
                    customMascotSize: CGSize(width: 180, height: 180)
                ) {
                    VStack(spacing: 36) {
                        // Title
                        Text(L10n.BossLevel.evaluating)
                            .dialogTitleStyle()
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 10)

                        // Spinner Arc
                        Circle()
                            .trim(from: 0.0, to: 0.35)
                            .stroke(
                                Color.appAccentOrange,
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 56, height: 56)
                            .rotationEffect(.degrees(isSpinning ? 360 : 0))
                            .animation(
                                .linear(duration: 1.0).repeatForever(autoreverses: false),
                                value: isSpinning
                            )
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .opacity(animateContent ? 1 : 0)

                        // Subtitle
                        Text(L10n.BossLevel.evaluatingSubtitle)
                            .dialogSubtitleStyle()
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 10)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .onAppear {
            isSpinning = true
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateContent = true
            }
        }
    }
}

#Preview {
    BossLevelEvaluatingView()
}
