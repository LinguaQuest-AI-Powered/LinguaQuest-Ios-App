//
//  SocialLoginButton.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct SocialLoginButton: View {
    var icon: String
    var title: String
    var isSystemIcon: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isSystemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#071E27"))
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .tracking(0.8)
                    .foregroundColor(Color(hex: "#071E27"))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color(hex: "#F3FAFF"))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color(hex: "#DBC2AD"), lineWidth: 2)
            )
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack(spacing: 20) {
            SocialLoginButton(
                icon: "googleIcon",
                title: "Continue with Google",
                isSystemIcon: false,
                action: { }
            )
            
            SocialLoginButton(
                icon: "appleIcon",
                title: "Continue with Apple",
                isSystemIcon: false,
                action: { }
            )
        }
        .padding()
    }
}
