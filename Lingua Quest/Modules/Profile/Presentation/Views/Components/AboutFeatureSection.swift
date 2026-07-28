//
//  AboutFeatureSection.swift
//  Lingua Quest
//
//  Created by taqieallah on 27/07/2026.
//

import SwiftUI

struct AboutFeatureSection: View {
    // MARK: - Properties
    @State private var animateCards: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SettingsGroupLabel(title: L10n.About.featuresTitle)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                featureCard(
                    icon: .sparkles,
                    iconBg: .appSemanticSuccess,
                    title: L10n.About.featureAiTitle,
                    description: L10n.About.featureAiDesc,
                    delay: 0.1
                )
                
                featureCard(
                    icon: .cameraFill,
                    iconBg: .appAccentOrange,
                    title: L10n.About.featureCameraTitle,
                    description: L10n.About.featureCameraDesc,
                    delay: 0.2
                )
                
                featureCard(
                    icon: .trophyFill,
                    iconBg: .appAccentGold,
                    title: L10n.About.featureGameTitle,
                    description: L10n.About.featureGameDesc,
                    delay: 0.3
                )
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateCards = true
            }
        }
    }
    
    // MARK: - View Builders
    @ViewBuilder
    private func featureCard(icon: Image.SystemIcon, iconBg: Color, title: String, description: String, delay: Double) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemIcon: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.appTextOnPrimary)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBg)
                )
                .shadow(color: iconBg.opacity(0.3), radius: 6, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .appTextStyle(.bodyBold, color: .appTextHeading)
                
                Text(description)
                    .appTextStyle(.caption, color: .appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.appSurfaceCard)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.appBorderCool.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.04), radius: 12, x: 0, y: 4)
        .scaleEffect(animateCards ? 1.0 : 0.94)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay), value: animateCards)
    }
}

#Preview {
    AboutFeatureSection()
        .padding()
        .background(Color.appBackgroundWarm)
}
