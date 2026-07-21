//
//  NotEnoughCoinsDialog.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

struct NotEnoughCoinsDialog: View {
    let missingCoins: Int
    let action: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .notEnoughCoins,
            speechBubbleText: nil
        ) {
            VStack(spacing: 16) {
                Text(L10n.Game.notEnoughCoinsTitle)
                    .appTextStyle(.displayMedium, color: .appBrandBrown)
                
                Text(L10n.Game.notEnoughCoinsSubtitle)
                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                RewardBadge(type: .coin, value: "-\(missingCoins)", size: .normal)
                
                CustomButton(
                    type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                    text: L10n.Game.getMoreCoins,
                    action: action,
                    leading: Image(systemIcon: .dollarsignCircleFill)
                )
                .padding(.top, 16)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        NotEnoughCoinsDialog(missingCoins: 20, action: {})
            .padding(24)
    }
}
