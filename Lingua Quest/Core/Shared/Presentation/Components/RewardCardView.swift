//
//  RewardCardView.swift
//  Lingua Quest
//
//  Created by siam on 08/08/2026.
//

import SwiftUI

struct RewardCardView: View {
    let type: RewardBadgeType
    let title: String
    let amount: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Outer glow/background
                Circle()
                    .fill(type.color.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                // White backing for the cutout
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                
                // Icon
                Image(systemIcon: type.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .foregroundColor(type.color)
            }
            
            Text(title)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
            
            Text("+\(amount) \(suffixString)")
                .appTextStyle(.bodyBold, color: .appBrandBrown)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.84 : 0.94))
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(type.color.opacity(colorScheme == .dark ? 0.28 : 0.16), lineWidth: 1)
                )
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.appSurfaceCard)
        .cornerRadius(16)
        .shadow(color: type.color.opacity(0.1), radius: 15, x: 0, y: 4)
    }
    
    private var suffixString: String {
        switch type {
        case .coin: return "$"
        case .xp: return "XP"
        case .custom: return ""
        }
    }
}
