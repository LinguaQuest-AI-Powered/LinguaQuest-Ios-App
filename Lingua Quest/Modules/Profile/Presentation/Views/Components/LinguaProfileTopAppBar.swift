//
//  LinguaProfileTopAppBar.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct LinguaProfileTopAppBar: View {
    // MARK: - Properties
    var coinsValue: String
    var gemsValue: String
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: Logo & Title
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.appSurfaceCard)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.appBrandPrimary.opacity(0.8),
                                            Color.appAccentGold.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    
                    Image(asset: .bird)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                
                Text(L10n.Profile.title)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
            }
            
            Spacer()
            
            // MARK: Badges Section
            HStack(spacing: 8) {
                // Coins Badge
                BadgeView(
                    icon: .dollarsignCircleFill,
                    iconColor: .appAccentGold,
                    value: coinsValue
                )
                
                // Gems Badge
                BadgeView(
                    icon: .diamondFill,
                    iconColor: .appAccentRed,
                    value: gemsValue,
                    iconSize: 10
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.appSurfaceNavBar)
        .overlay(
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.appBorderBrown),
            alignment: .bottom
        )
    }
}

// MARK: - Preview
#Preview {
    VStack {
        LinguaProfileTopAppBar(coinsValue: "1,250", gemsValue: "45")
        Spacer()
    }
    .background(Color.appBackgroundWarm)
}
