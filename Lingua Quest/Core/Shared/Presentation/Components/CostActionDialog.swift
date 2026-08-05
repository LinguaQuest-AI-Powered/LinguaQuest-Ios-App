//
//  CostActionDialog.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

struct CostActionDialog: View {
    let title: String
    let subtitle: String
    let cost: Int
    let mascotImage: Image.Asset
    let primaryButtonText: String
    let primaryButtonIcon: Image.SystemIcon?
    let primaryAction: () -> Void
    let cancelAction: () -> Void
    var customMascotSize: CGSize = CGSize(width: 280, height: 192)
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: mascotImage,
            customMascotSize: customMascotSize,
            speechBubbleText: nil
        ) {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(title)
                        .dialogTitleStyle()
                    
                    Text(subtitle)
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                // Badge for coins
                RewardBadge(type: .coin, value: "-\(cost)", size: .normal)
                
                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                        text: primaryButtonText,
                        action: primaryAction,
                        leading: primaryButtonIcon != nil ? Image(systemIcon: primaryButtonIcon!) : nil
                    )
                    
                    OutlineButton(
                        text: L10n.Common.cancel,
                        action: cancelAction,
                        color: .appTealGreen
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}