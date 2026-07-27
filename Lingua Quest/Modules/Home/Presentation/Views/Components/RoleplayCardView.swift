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
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.BossLevel.interactiveScenarios)
                        .font(AppTextStyle.displaySmall.font)
                        .foregroundColor(.appTextHeading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                    
                    Text(L10n.BossLevel.roleplayTag)
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(.appTextSecondary)
                    
                    Spacer()
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appAccentOrange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.appAccentOrange.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: Color.appAccentOrange.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    Image(asset: .bird3)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 68, height: 68)
                        .offset(y: 4)
                }
                .frame(width: 80, height: 80)
            }
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                        .font(.system(size: 16, weight: .bold))
                    Text(L10n.BossLevel.browseRoleplays)
                        .font(AppTextStyle.bodyBold.font)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appAccentOrange)
                .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        RoleplayCardView(action: {})
            .padding()
    }
}
