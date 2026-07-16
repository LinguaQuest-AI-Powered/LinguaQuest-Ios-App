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

            Image(asset: .onboardingbackground)
                .resizable()
                .ignoresSafeArea()

            Image(asset: .star2)
                .position(x: 45, y: 90)

            Image(asset: .ball)
                .position(x: 320, y: 220)


            VStack(spacing: 0) {
                Spacer().frame(height: 70)

                Image(.bird2)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)

                Spacer().frame(height: 28)

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
        }
    }
}

#Preview {
    WelcomeStepView(
        onGetStarted: { print("Get Started tapped") },
        onLogin: { print("Login tapped") }
    )
}
