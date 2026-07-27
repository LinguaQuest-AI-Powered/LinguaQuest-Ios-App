//
//  AboutCommunitySection.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI

struct AboutCommunitySection: View {
    // MARK: - Properties
    var onRateAppTapped: () -> Void
    var onWebsiteTapped: () -> Void
    var onPrivacyPolicyTapped: () -> Void
    var onTermsOfServiceTapped: () -> Void
    
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
                    externalLinkIcon
                }
                .onTapGesture(perform: onRateAppTapped)
                
                LinguaSettingsRow(
                    icon: .globe,
                    iconBgColor: .appBrandPrimary,
                    title: L10n.About.website,
                    showDivider: true
                ) {
                    externalLinkIcon
                }
                .onTapGesture(perform: onWebsiteTapped)
                
                LinguaSettingsRow(
                    icon: .shieldFill,
                    iconBgColor: .appAccentTeal,
                    title: L10n.About.privacyPolicy,
                    showDivider: true
                ) {
                    externalLinkIcon
                }
                .onTapGesture(perform: onPrivacyPolicyTapped)
                
                LinguaSettingsRow(
                    icon: .docTextFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.About.termsOfService,
                    showDivider: false
                ) {
                    externalLinkIcon
                }
                .onTapGesture(perform: onTermsOfServiceTapped)
            }
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appTextPrimary.opacity(0.05), radius: 20, x: 0, y: 6)
        }
    }
    
    // MARK: - Subviews
    private var externalLinkIcon: some View {
        Image(systemIcon: .arrowUpRight)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.appBorderBrown)
            .flipsForRightToLeftLayoutDirection(true)
    }
}

#Preview {
    AboutCommunitySection(
        onRateAppTapped: {},
        onWebsiteTapped: {},
        onPrivacyPolicyTapped: {},
        onTermsOfServiceTapped: {}
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
