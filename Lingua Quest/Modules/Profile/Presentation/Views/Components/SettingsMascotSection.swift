//
//  SettingsMascotSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsMascotSection: View {
    // MARK: - Properties
    let userName: String
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Outer Glow
                Circle()
                    .fill(Color.appAccentGold.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                // Background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.appSurfaceCard, Color.appSurfaceCard.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.appBrandPrimary.opacity(0.6), Color.appAccentGold.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Image(asset: .mascotSettings)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .offset(y: 4) // Adjust mascot position slightly
            }
            .padding(.bottom, 8)
            
            Text(userName)
                .appTextStyle(.displayLarge, color: .appTextHeading)
            
            Text(L10n.Settings.subtitle)
                .appTextStyle(.bodyLarge, color: .appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    SettingsMascotSection(userName: "Explorer Alex")
        .padding()
        .background(Color.appBackgroundWarm)
}
