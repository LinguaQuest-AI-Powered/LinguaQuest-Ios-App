//
//  HelpAndSupportView.swift
//  Lingua Quest
//
//  Created by taqieallah on 28/07/2026.
//

import SwiftUI

struct HelpAndSupportView: View {
    // MARK: - Properties
    @State var viewModel: HelpAndSupportViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // App Bar
            HStack {
                CustomBackButton(action: { viewModel.onBackTapped() })
                Spacer()
            }
            .overlay(
                Text(L10n.HelpSupport.title)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
            )
            .padding(.horizontal, 20)
            .frame(height: 64)
            .padding(.bottom, 20)
            
            Spacer()
            
            // Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    VStack(spacing: 0) {
                        LinguaSettingsRow(
                            icon: .questionmarkCircleFill,
                            iconBgColor: .appAccentTeal,
                            title: L10n.HelpSupport.faq,
                            showDivider: true
                        ) {
                            SettingsRowChevron()
                        }
                        
                        LinguaSettingsRow(
                            icon: .exclamationmarkTriangleFill,
                            iconBgColor: .appAccentRed,
                            title: L10n.HelpSupport.reportBug,
                            showDivider: true
                        ) {
                            SettingsRowChevron()
                        }
                        
                        LinguaSettingsRow(
                            icon: .personCropCircleFill,
                            iconBgColor: .appBrandPrimary,
                            title: L10n.HelpSupport.communityForum,
                            showDivider: false
                        ) {
                            SettingsRowChevron()
                        }
                    }
                    .background(Color.appSurfaceCard)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appBorderBrown.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Contact Info Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.HelpSupport.contactUs)
                            .appTextStyle(.headingMedium, color: .appTextHeading)
                            .padding(.leading, 8)
                        
                        VStack(spacing: 0) {
                            LinguaSettingsRow(
                                icon: .envelopeFill,
                                iconBgColor: .appAccentOrange,
                                title: "Email",
                                showDivider: true
                            ) {
                                Text("support@linguaquest.com")
                                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            }
                            
                            LinguaSettingsRow(
                                icon: .phoneFill,
                                iconBgColor: .appAccentTeal,
                                title: "Phone",
                                showDivider: true
                            ) {
                                Text("+1 (555) 123-4567")
                                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            }
                            
                            LinguaSettingsRow(
                                icon: .mappinAndEllipse,
                                iconBgColor: .appAccentRed,
                                title: "Address",
                                showDivider: false
                            ) {
                                Text("123 Lingua St, NY")
                                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            }
                        }
                        .background(Color.appSurfaceCard)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.appBorderBrown.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        
        }
        .background(Color.appBackgroundPrimary.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
