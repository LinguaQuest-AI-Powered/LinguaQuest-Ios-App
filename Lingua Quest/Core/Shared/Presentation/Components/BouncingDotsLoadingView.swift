//
//  BouncingDotsLoadingView.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import SwiftUI

struct BouncingDotsLoadingView: View {
    var text: String
    @State private var isAnimating = false
    @State private var textOpacity: Double = 0.6
    
    init(text: String = L10n.Common.loading) {
        self.text = text
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(dotColor(for: index))
                        .frame(width: 16, height: 16)
                        .offset(y: isAnimating ? -8 : 8)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                isAnimating = true
            }
            
            Text(text)
                .appTextStyle(.bodyBold, color: .appTextSecondary)
                .opacity(textOpacity)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        textOpacity = 1.0
                    }
                }
        }
    }
    
    private func dotColor(for index: Int) -> Color {
        switch index {
        case 0: return .appAccentOrange
        case 1: return .appBrandBrown
        default: return .appAccentGold
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        BouncingDotsLoadingView()
    }
}
