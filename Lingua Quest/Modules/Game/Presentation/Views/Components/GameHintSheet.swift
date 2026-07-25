//
//  GameHintSheet.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import SwiftUI

struct GameHintSheet: View {
    let coins: Int
    let onClose: () -> Void
    let onSelectHint: (String) -> Void
    let onNotEnoughCoins: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                // Coins removed
                
                Spacer()
                
                // Close Button
                Button(action: onClose) {
                    Image(systemIcon: .xmark)
                        .appTextStyle(.bodyBold, color: .appBrandPrimary)
                        .frame(width: 36, height: 36)
                        .background(Color.appBrandPrimary.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            // Mascot
            Image(asset: .birdIdea)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
            
            // Title
            Text(L10n.Game.needHintTitle)
                .appTextStyle(.displaySmall, color: .appBrandPrimary)
            
            // Options
            VStack(spacing: 16) {
                hintOptionCard(
                    iconText: "?",
                    iconSystemName: nil,
                    title: L10n.Game.hintGetHint,
                    cost: AppConstants.Common.hintCost,
                    action: {
                        if coins >= AppConstants.Common.hintCost {
                            onSelectHint("HINT") // The actual hint logic will call API and show the hint
                        } else {
                            onNotEnoughCoins()
                        }
                    }
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
        }
    }
    
    private func hintOptionCard(iconText: String?, iconSystemName: String?, title: String, cost: Int, action: @escaping () -> Void) -> some View {
        HStack(spacing: 16) {
            // Icon
            Group {
                if let systemName = iconSystemName {
                    Image(systemName: systemName)
                        .font(.system(size: 24, weight: .semibold))
                } else if let text = iconText {
                    Text(text)
                        .appTextStyle(.headingMediumBold)
                }
            }
            .foregroundColor(.appTealGreen)
            .frame(width: 50, height: 50)
            .background(Color.appBackgroundWarm)
            .clipShape(Circle())
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .appTextStyle(.bodyBold, color: .appTextPrimary)
                
                HStack(spacing: 4) {
                    Image(systemIcon: .dollarsignCircleFill)
                        .appTextStyle(.captionMedium, color: .appAccentGold)
                    Text("\(cost)")
                        .appTextStyle(.captionMedium, color: .appTextSecondary)
                }
            }
            
            Spacer()
            
            // Button
            Button(action: action) {
                Text(L10n.Game.useHint)
                    .appTextStyle(.bodyBold, color: .appTextOnPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.appBrandPrimary)
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.appBorderLight, lineWidth: 2)
        )
    }
}
