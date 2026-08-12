//
//  OutlineButton.swift
//  Lingua Quest
//
//  Created by siam on 17/07/2026.
//

import SwiftUI

struct OutlineButton: View {
    let text: String
    let action: () -> Void
    var color: Color = Color.appOutlineButton
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .appTextStyle(.bodyLargeBold, color: color)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .contentShape(Rectangle())
        }
        .background(Color.clear)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color, lineWidth: 2)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        OutlineButton(text: "Skip", action: {})
        OutlineButton(text: "Cancel", action: {}, color: .red)
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
