//
//  AboutView.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI

struct AboutView: View {
    // MARK: - Properties
    @State var viewModel: AboutViewModel
    @State private var appearAnimation: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                appBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        heroSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                        
                        missionCard
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 25)
                        
                        linksSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 30)
                        
                        legalSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 35)
                        
                        footerSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 48)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appearAnimation = true
            }
        }
        .appDialog(isPresented: $viewModel.showLicensesDialog) {
            DialogCardContainer(
                showMascot: true,
                mascotImage: .loginBird,
                speechBubbleText: L10n.About.licenses
            ) {
                VStack(spacing: 16) {
                    Text(L10n.About.licensesTitle)
                        .dialogTitleStyle()
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.About.licensesDescription)
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                    
                    CustomButton(
                        type: .primary,
                        text: L10n.Common.ok,
                        action: { viewModel.showLicensesDialog = false }
                    )
                    .padding(.top, 8)
                }
            }
        }
        .appDialog(isPresented: $viewModel.showComingSoonDialog) {
            DialogCardContainer(
                showMascot: true,
                mascotImage: .loginBird,
                speechBubbleText: "Coming Soon!"
            ) {
                VStack(spacing: 16) {
                    Text(L10n.Common.underConstruction)
                        .appTextStyle(.bodyMedium, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    CustomButton(
                        type: .primary,
                        text: L10n.Common.ok,
                        action: { viewModel.showComingSoonDialog = false }
                    )
                    .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var appBar: some View {
        HStack {
            CustomBackButton(action: { viewModel.onBackTapped() })
            Spacer()
        }
        .overlay(
            Text(L10n.About.title)
                .appTextStyle(.headingLarge, color: .appTextHeading)
        )
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.clear)
    }
    
    private var heroSection: some View {
        VStack(spacing: 24) {
            Image(asset: .loginBird)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
            
            VStack(spacing: 4) {
                Text(L10n.About.appName)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
                
                Text(viewModel.appVersion)
                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
            }
        }
    }
    
    private var missionCard: some View {
        Text(L10n.About.missionDescription)
            .appTextStyle(.bodyMedium, color: .appTextSecondary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
    }
    
    private var linksSection: some View {
        VStack(spacing: 12) {
            Button(action: { viewModel.onRateAppTapped() }) {
                LinguaSettingsRow(
                    icon: .starFill,
                    iconBgColor: .appBrandBrown,
                    title: L10n.About.rateApp,
                    showDivider: false
                ) {
                    SettingsRowChevron()
                }
            }
            .buttonStyle(.plain)
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
            
            Button(action: { viewModel.onInstagramTapped() }) {
                LinguaSettingsRow(
                    icon: .cameraFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.About.instagram,
                    showDivider: false
                ) {
                    SettingsRowChevron()
                }
            }
            .buttonStyle(.plain)
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
            
            Button(action: { viewModel.onWebsiteTapped() }) {
                LinguaSettingsRow(
                    icon: .globe,
                    iconBgColor: .appAccentGold,
                    title: L10n.About.website,
                    showDivider: false
                ) {
                    SettingsRowChevron()
                }
            }
            .buttonStyle(.plain)
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            // Terms of Service
            Button(action: { viewModel.onTermsTapped() }) {
                HStack(spacing: 16) {
                    Image(systemIcon: .docTextFill)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.appTextSecondary)
                    
                    Text(L10n.About.termsOfService)
                        .appTextStyle(.bodyLargeMedium, color: .appTextHeading)
                    
                    Spacer()
                    SettingsRowChevron()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Divider().background(Color.appBorderBrown.opacity(0.5)).padding(.leading, 16)
            
            // Privacy Policy
            Button(action: { viewModel.onPrivacyTapped() }) {
                HStack(spacing: 16) {
                    Image(systemIcon: .shieldFill)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.appTextSecondary)
                    
                    Text(L10n.About.privacyPolicy)
                        .appTextStyle(.bodyLargeMedium, color: .appTextHeading)
                    
                    Spacer()
                    SettingsRowChevron()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Divider().background(Color.appBorderBrown.opacity(0.5)).padding(.leading, 16)
            
            // Licenses & Credits
            Button(action: { viewModel.onLicensesTapped() }) {
                HStack(spacing: 16) {
                    Image(systemIcon: .infoCircleFill)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.appTextSecondary)
                    
                    Text(L10n.About.licenses)
                        .appTextStyle(.bodyLargeMedium, color: .appTextHeading)
                    
                    Spacer()
                    SettingsRowChevron()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Color.appSurfaceCard)
        .cornerRadius(20)
        .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
    }
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text(L10n.About.madeWithLove)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
                .multilineTextAlignment(.center)
            
            Text(L10n.About.copyright)
                .appTextStyle(.micro, color: .appTextSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }
}

#Preview {
    let dummyRouter = Router()
    let dummyViewModel = AboutViewModel(router: dummyRouter)
    return AboutView(viewModel: dummyViewModel)
}
