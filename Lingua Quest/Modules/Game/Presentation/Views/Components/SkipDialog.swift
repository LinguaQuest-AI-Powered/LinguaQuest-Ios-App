//
//  SkipDialog.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//


import SwiftUI

struct SkipDialog: View {
    let skip: () -> Void
    let cancel: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .skip,
            customMascotSize: CGSize(width: 280, height: 192),
            speechBubbleText: nil
        ) {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(L10n.Game.skipWordTitle)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                    
                    Text(L10n.Game.skipWordSubtitle(200))
                        .appTextStyle(.body, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                // Badge for coins
                HStack(spacing: 6) {
                    Image(systemIcon: .dollarsignCircleFill)
                        .foregroundColor(.appAccentOrange)
                    Text("-200")
                        .appTextStyle(.headingMediumBold, color: .appAccentOrange)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.appAccentOrange.opacity(0.1))
                .clipShape(Capsule())
                
                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                        text: L10n.Game.skipWordAction,
                        action: skip,
                        leading: Image(systemIcon: .forwardFill)
                    )
                    
                    OutlineButton(
                        text: L10n.Common.cancel,
                        action: cancel,
                        color: .appTealGreen
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}