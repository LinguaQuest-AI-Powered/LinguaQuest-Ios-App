//
//  LoadingView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Reusable loading state used across screens
struct LoadingView: View {

    // MARK: - State

    @State private var isFloating = false
    @State private var dot1 = false
    @State private var dot2 = false
    @State private var dot3 = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Bird
            Image(asset: .loadingBird)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .offset(y: isFloating ? -8 : 0)
                .animation(
                    .easeInOut(duration: 1.1)
                    .repeatForever(autoreverses: true),
                    value: isFloating
                )
                .shadow(color: Color.appAccentOrange.opacity(0.25), radius: 18, x: 0, y: 10)

            // Ellipse shadow under bird
            Ellipse()
                .fill(Color.appAccentOrange.opacity(0.12))
                .frame(width: 70, height: 12)
                .scaleEffect(isFloating ? 0.8 : 1.05)
                .animation(
                    .easeInOut(duration: 1.1)
                    .repeatForever(autoreverses: true),
                    value: isFloating
                )
                .padding(.top, 4)

            Spacer().frame(height: 28)

            // Dots
            HStack(spacing: 8) {
                dot(active: dot1, delay: 0.0)
                dot(active: dot2, delay: 0.2)
                dot(active: dot3, delay: 0.4)
            }

            Spacer().frame(height: 14)

            Text(L10n.Common.loading)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .onAppear {
            isFloating = true
            animateDots()
        }
    }

    // MARK: - Dot

    private func dot(active: Bool, delay: Double) -> some View {
        Circle()
            .fill(Color.appAccentOrange.opacity(active ? 1.0 : 0.25))
            .frame(width: 8, height: 8)
            .scaleEffect(active ? 1.3 : 1.0)
            .animation(.easeInOut(duration: 0.4), value: active)
    }

    // MARK: - Dot Animation

    private func animateDots() {
        let step: Double = 0.35
        func cycle() {
            dot1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + step) { dot2 = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + step * 2) { dot3 = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + step * 3) {
                dot1 = false; dot2 = false; dot3 = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { cycle() }
            }
        }
        cycle()
    }
}

// MARK: - Preview

#Preview {
    LoadingView()
        .background(Color.appBackgroundWarm)
}
