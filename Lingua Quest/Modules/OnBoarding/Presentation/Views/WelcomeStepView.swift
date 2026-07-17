//
//  WelcomeStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct WelcomeStepView: View {
    let onGetStarted: () -> Void
    let onLogin: () -> Void

    var body: some View {
        ZStack {

            Color.appViewBackground
                .ignoresSafeArea()

            VStack {
                Spacer()
                Image(asset: .onBoardingBottomSVG)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea(edges: .bottom)
            
            
            VStack(spacing: 0) {
                
                Image(asset: .onBoardingFirstBird)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .scaleEffect(1.35)
                    .padding(.bottom, -20)

                (Text(L10n.Onboarding.welcomeTitlePart1)
                    .foregroundColor(.black) +
                Text(L10n.Onboarding.welcomeTitlePart2)
                    .foregroundColor(.appPrimary))
                .font(AppTextStyle.title.font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    CustomButton(
                        type: .primary,
                        text: L10n.Onboarding.welcomeGetStarted,
                        action: onGetStarted
                    )

                    CustomButton(
                        type: .secendry,
                        text: L10n.Onboarding.welcomeAlreadyHaveAccount,
                        action: onLogin
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 80)
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    WelcomeStepView(
        onGetStarted: { print("Get Started tapped") },
        onLogin: { print("Login tapped") }
    )
}
