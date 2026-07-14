//
//  SocialLoginButton.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 14/07/2026.
//

import SwiftUI

struct SocialLoginButton: View {
    var icon: Image.Icon
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .appTextStyle(.buttonBold, color: .textDarkBlue)
                    .tracking(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.backgroundLightBlue)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.borderBrown, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack(spacing: 20) {
            SocialLoginButton(
                icon: .google,
                title: L10n.Auth.continueWithGoogle,
                action: { }
            )
            
            SocialLoginButton(
                icon: .apple,
                title: L10n.Auth.continueWithApple,
                action: { }
            )
        }
        .padding()
    }
}
