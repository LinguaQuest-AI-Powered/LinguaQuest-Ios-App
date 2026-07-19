//
//  CustomTextField.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct CustomTextField: View {
    var icon: Image.SystemIcon
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemIcon: icon)
                .foregroundColor(.appIconBrown)
                .frame(width: 20)
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(Color.appTextSecondary.opacity(0.5))
            )
            .appTextStyle(.body, color: .appTextSecondary)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(.horizontal, 24)
        .frame(height: 52)
        .background(Color.appBackgroundPrimary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.appBorderBrown, lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        CustomTextField(
            icon: .envelopeFill,
            placeholder: L10n.Auth.emailPlaceholder,
            text: .constant("")
        )
        .padding()
    }
}
