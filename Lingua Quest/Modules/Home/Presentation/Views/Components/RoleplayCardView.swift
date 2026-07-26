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
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    // Tag pill
                    Text(L10n.BossLevel.roleplayTag)
                        .appTextStyle(.microSemibold, color: .appBrandBrown)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.appAccentOrange.opacity(0.15))
                        .clipShape(Capsule())

                    Text(L10n.BossLevel.interactiveScenarios)
                        .font(AppTextStyle.headingLarge.font)
                        .foregroundColor(.appTextHeading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appAccentOrange.opacity(0.12))
                        .frame(width: 76, height: 76)

                    Image(asset: .bird3)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            }

            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemIcon: .play)
                        .font(.system(size: 16, weight: .bold))
                    Text(L10n.BossLevel.browseRoleplays)
                        .font(AppTextStyle.bodyBold.font)
                }
                .foregroundColor(.appTextOnPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appAccentOrange)
                .clipShape(Capsule())
            }
            .buttonStyle(HomeScaleButtonStyle())
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
