//
//  CustomSecureField.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct CustomSecureField: View {
    var icon: Image.SystemIcon
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemIcon: icon)
                .foregroundColor(.appIconBrown)
                .frame(width: 20)
            
            Group {
                if isVisible {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color.appTextSecondary.opacity(0.5))
                    )
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color.appTextSecondary.opacity(0.5))
                    )
                }
            }
            .appTextStyle(.body, color: .appTextSecondary)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemIcon: isVisible ? .eyeSlashFill : .eyeFill)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 16)
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
        
        VStack(spacing: 20) {
            CustomSecureField(
                icon: .lockFill,
                placeholder: L10n.Auth.passwordPlaceholder,
                text: .constant(""),
                isVisible: .constant(false)
            )
            
            CustomSecureField(
                icon: .lockFill,
                placeholder: L10n.Auth.passwordPlaceholder,
                text: .constant("MySecretPass123!"),
                isVisible: .constant(true)
            )
        }
        .padding()
    }
}
