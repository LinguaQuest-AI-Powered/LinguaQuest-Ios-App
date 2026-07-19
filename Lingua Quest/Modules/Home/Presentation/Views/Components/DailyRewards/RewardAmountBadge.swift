//
//  RewardAmountBadge.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct RewardAmountBadge: View {
    // MARK: - Properties
    let amount: Int
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 8) {
            Image(systemIcon: .dollarsignCircleFill)
                .font(.system(size: 18))
                .foregroundColor(.appBrandBrown)
            
            Text(L10n.Home.dailyRewardCoinsFormat(amount))
                .appTextStyle(.bodyLargeBold, color: .appTextHeading)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .background(Capsule().fill(Color.appSurfaceCardWarm))
    }
}

// MARK: - Preview
#Preview {
    RewardAmountBadge(amount: 50)
        .padding()
        .background(Color.appBackgroundWarm)
}
