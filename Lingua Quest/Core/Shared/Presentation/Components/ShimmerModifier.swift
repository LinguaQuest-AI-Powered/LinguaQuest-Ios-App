//
//  ShimmerModifier.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 22/07/2026.
//

import SwiftUI

public struct ShimmerModifier: ViewModifier {
    @State private var isInitialState = true
    
    public func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.4), .black, .black.opacity(0.4)]),
                    startPoint: (isInitialState ? .init(x: -0.3, y: -0.3) : .init(x: 1, y: 1)),
                    endPoint: (isInitialState ? .init(x: 0, y: 0) : .init(x: 1.3, y: 1.3))
                )
            )
            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isInitialState)
            .onAppear {
                isInitialState = false
            }
    }
}

public extension View {
    @ViewBuilder
    func shimmer(active: Bool = true) -> some View {
        if active {
            self.modifier(ShimmerModifier())
        } else {
            self
        }
    }
}
