//
//  NotEnoughCoinsDialog.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

struct NotEnoughCoinsDialog: View {
    let title: String
    let subtitle: String
    let missingCoins: Int
    let action: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .notEnoughCoins,
            speechBubbleText: nil
        ) {
            VStack(spacing: 16) {
                Text(title)
                    .appTextStyle(.displayMedium, color: .appBrandBrown)
                
                Text(subtitle)
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
        NotEnoughCoinsDialog(
            title: "لا يوجد عملات كافية!",
            subtitle: "تحتاج إلى المزيد من العملات لاستخدام هذه المساعدة.",
            missingCoins: 20,
            action: {}
        )
        .padding(24)
    }
}
