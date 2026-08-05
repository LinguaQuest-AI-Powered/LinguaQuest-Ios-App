//
//  LinguaSettingsPromptCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct LinguaSettingsPromptCard: View {
    // MARK: - Properties
    var action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Gamified Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.appBrandPrimary)
                        .shadow(color: .appBrandBrownDark, radius: 0, x: 0, y: 3)
                    
                    Image(systemIcon: .sliderHorizontal3)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.appTextOnPrimary)
                }
                .frame(width: 52, height: 52)
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Profile.settingsCardTitle)
                        .appTextStyle(.bodyLargeBold, color: .appTextHeading)
                    
                    Text(L10n.Profile.settingsCardSubtitle)
                        .appTextStyle(.captionMedium, color: .appTextSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Action Indicator
                ZStack {
                    Circle()
                        .fill(Color.appBackgroundWarm)
                        .frame(width: 32, height: 32)
                    
                    Image(systemIcon: .rightChevron)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.appBrandBrown)
                        .flipsForRightToLeftLayoutDirection(true)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.appSurfaceCard)
                    .shadow(color: Color.appBorderBrown.opacity(0.4), radius: 0, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.appBorderBrown, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 4)
    }
}

// MARK: - Preview
#Preview {
    LinguaSettingsPromptCard {
        print("Settings Tapped!")
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
