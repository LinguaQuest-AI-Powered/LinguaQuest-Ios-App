//
//  LinguaStatCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct StatCard: View {
    // MARK: - Properties
    let value: String
    let title: String
    let icon: Image.SystemIcon
    let iconColor: Color
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            Image(systemIcon: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
            
            Text(value)
                .appTextStyle(.bodyLargeBold, color: .appTextDark)
            
            Text(title)
                .appTextStyle(.microHeavy, color: .appTextSecondary.opacity(0.7))
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSurfaceCardWarm)
                .shadow(color: .appBorderWarm, radius: 0, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.appBorderWarm, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 16) {
        StatCard(
            value: "1,250",
            title: L10n.Profile.coins,
            icon: .checkmarkCircleFill,
            iconColor: .appIconBrown
        )
        
        StatCard(
            value: "7 Days",
            title: L10n.Profile.streak,
            icon: .flameFill,
            iconColor: .red
        )
    }
    .padding()
}
