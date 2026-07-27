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
    @State private var isBouncing: Bool = false
    @State private var appearAnimation: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                appBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        heroSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                        
                        missionCard
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 25)
                        
                        AboutFeatureSection()
                        
                        AboutCommunitySection()
                        
                        footerSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appearAnimation = true
            }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                isBouncing = true
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
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.appBorderBrown),
            alignment: .bottom
        )
    }
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.appGlowOrange.opacity(0.5))
                    .frame(width: 140, height: 140)
                    .blur(radius: 16)
                
                Image(asset: .mascotSettings)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .offset(y: isBouncing ? -8 : 8)
            }
            .frame(height: 150)
            
            VStack(spacing: 6) {
                Text(L10n.About.appName)
                    .appTextStyle(.displayMedium, color: .appTextHeading)
                
                Text(viewModel.appVersion)
                    .appTextStyle(.captionBold, color: .appBrandPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.appBrandPrimary.opacity(0.12))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.appBrandPrimary.opacity(0.3), lineWidth: 1)
                    )
                
                Text(L10n.About.subtitle)
                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
    }
    
    private var missionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemIcon: .sparkles)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.appAccentOrange)
                
                Text(L10n.About.missionTitle)
                    .appTextStyle(.bodyLargeBold, color: .appTextHeading)
            }
            
            Text(L10n.About.missionDescription)
                .appTextStyle(.body, color: .appTextSecondary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appSurfaceCardWarm)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBorderBrown.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.04), radius: 14, x: 0, y: 4)
    }
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text(L10n.About.madeWithLove)
                .appTextStyle(.captionBold, color: .appTextSecondary)
                .multilineTextAlignment(.center)
            
            Text(L10n.About.copyright)
                .appTextStyle(.micro, color: .appTextSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }
}

#Preview {
    let dummyRouter = Router()
    let dummyViewModel = AboutViewModel(router: dummyRouter)
    return AboutView(viewModel: dummyViewModel)
}
