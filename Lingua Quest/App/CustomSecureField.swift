//
//  CustomSecureField.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#887361"))
                .frame(width: 20)
            
            Group {
                if isVisible {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color(hex: "#554434").opacity(0.5))
                    )
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(Color(hex: "#554434").opacity(0.5))
                    )
                }
            }
            .foregroundColor(Color(hex: "#554434"))
            .font(.system(size: 16))
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Color(hex: "#554434"))
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 16)
        .frame(height: 52)
        .background(Color(hex: "#F3FAFF"))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color(hex: "#DBC2AD"), lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack(spacing: 20) {
            CustomSecureField(
                icon: "lock.fill",
                placeholder: "Password",
                text: .constant(""),
                isVisible: .constant(false)
            )
            
            CustomSecureField(
                icon: "lock.fill",
                placeholder: "Password",
                text: .constant("MySecretPass123!"),
                isVisible: .constant(true)
            )
        }
        .padding()
    }
}
