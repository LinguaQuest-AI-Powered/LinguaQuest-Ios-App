//
//  RoleplayCardView.swift
//  Lingua Quest
//
//  Created by taqieallah on 26/07/2026.
//

import SwiftUI

struct RoleplayCardView: View {
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appAccentOrange.opacity(0.1))
                    .frame(height: 90)
                
                Image(asset: .bird3)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 76)
                    .offset(y: 4)
            }
            .frame(maxWidth: .infinity)
            
            Text(L10n.BossLevel.interactiveScenarios)
                .font(AppTextStyle.bodyLargeMedium.font)
                .foregroundColor(.appTextHeading)
                .lineLimit(1)
            
            Text(L10n.BossLevel.roleplayTag)
                .font(AppTextStyle.micro.font)
                .foregroundColor(.appTextSecondary)
                .lineLimit(1)
            
            HStack(spacing: 6) {
                Label {
                    Text(L10n.Home.featureAiChat)
                } icon: {
                    Image(systemIcon: .sparkles)
                }
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.appAccentOrange)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.appAccentOrange.opacity(0.15))
                .cornerRadius(4)
                
                Label {
                    Text(L10n.Home.featureSpeaking)
                } icon: {
                    Image(systemIcon: .micFill)
                }
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.appAccentTeal)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.appAccentTeal.opacity(0.15))
                .cornerRadius(4)
            }
            
            Spacer(minLength: 0)
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                        .font(.system(size: 14, weight: .bold))
                    Text(L10n.BossLevel.browseRoleplays)
                        .font(AppTextStyle.captionMedium.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.appAccentOrange)
                .clipShape(Capsule())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appBorderLight.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        RoleplayCardView(action: {})
            .padding()
    }
}
