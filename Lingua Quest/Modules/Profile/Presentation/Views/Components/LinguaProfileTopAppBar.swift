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
                Image(asset: .bird)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Color.appBrandBrown, lineWidth: 2))
                
                Text(L10n.Profile.title)
                    .appTextStyle(.headingLarge, color: .appBrandBrown)
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
