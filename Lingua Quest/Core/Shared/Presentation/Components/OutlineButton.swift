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
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(color)
                .frame(maxWidth: .infinity, maxHeight: 32)
                .contentShape(Rectangle())
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(100)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(color, lineWidth: 1)
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
