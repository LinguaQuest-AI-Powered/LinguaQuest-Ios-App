//
//  AboutCommunitySection.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI

struct AboutCommunitySection: View {
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsGroupLabel(title: L10n.About.communityTitle)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                LinguaSettingsRow(
                    icon: .starFill,
                    iconBgColor: .appAccentGold,
                    title: L10n.About.rateApp,
                    showDivider: true
                ) {
                    EmptyView()
                }
                
                LinguaSettingsRow(
                    icon: .globe,
                    iconBgColor: .appBrandPrimary,
                    title: L10n.About.website,
                    showDivider: true
                ) {
                    EmptyView()
                }
                
                LinguaSettingsRow(
                    icon: .shieldFill,
                    iconBgColor: .appAccentTeal,
                    title: L10n.About.privacyPolicy,
                    showDivider: true
                ) {
                    EmptyView()
                }
                
                LinguaSettingsRow(
                    icon: .docTextFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.About.termsOfService,
                    showDivider: false
                ) {
                    EmptyView()
                }
            }
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appTextPrimary.opacity(0.05), radius: 20, x: 0, y: 6)
        }
    }
}

#Preview {
    AboutCommunitySection()
        .padding()
        .background(Color.appBackgroundWarm)
}
