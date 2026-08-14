//
//  HomeScaleButtonStyle.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
