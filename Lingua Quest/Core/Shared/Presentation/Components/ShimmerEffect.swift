//
//  ShimmerEffect.swift
//  Lingua Quest
//
//  Created by siam on 20/07/2026.
//

import SwiftUI

/// A ViewModifier that adds a modern shimmer effect to any view.
/// This is commonly used for loading skeletons.
struct ShimmerEffect: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: Color.appShimmerHighlight.opacity(0.6), location: 0.5),
                            .init(color: .clear, location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: width * 3) // Make the gradient larger than the view so it can move across
                    .offset(x: isAnimating ? width : -width * 2)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    /// Applies a shimmer effect over the view, acting as a loading skeleton.
    func shimmer(isActive: Bool = true) -> some View {
        Group {
            if isActive {
                self.modifier(ShimmerEffect())
            } else {
                self
            }
        }
    }
}
