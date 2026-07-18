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
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                // Coins
                HStack(spacing: 6) {
                    Image(systemIcon: .dollarsignCircleFill)
                        .foregroundColor(.appBrandPrimary)
                    Text("\(coins)")
                        .appTextStyle(.bodyBold, color: .appTextPrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.appSurfaceCard)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.appBorderCool, lineWidth: 1)
                )
                
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
                    iconText: "Aa",
                    iconSystemName: nil,
                    title: L10n.Game.hintRevealFirstLetter,
                    cost: 25,
                    action: { onSelectHint(L10n.Game.hintRevealFirstLetterMock) } // Mock
                )
                
                hintOptionCard(
                    iconText: nil,
                    iconSystemName: "info.circle",
                    title: L10n.Game.hintShowCategoryClue,
                    cost: 50,
                    action: { onSelectHint(L10n.Game.hintShowCategoryClueMock) } // Mock
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
            .background(Color.appViewBackground) // Using view background so it contrasts with the card
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
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.appBorderLight, lineWidth: 2)
        )
    }
}
