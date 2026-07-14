//
//  CustomTextField.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#887361"))
                .frame(width: 20)
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(Color(hex: "#554434").opacity(0.5))
            )
            .foregroundColor(Color(hex: "#554434"))
            .font(.system(size: 16))
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(.horizontal, 24)
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
        
        CustomTextField(
            icon: "envelope.fill",
            placeholder: "Email address",
            text: .constant("")
        )
        .padding()
    }
}
