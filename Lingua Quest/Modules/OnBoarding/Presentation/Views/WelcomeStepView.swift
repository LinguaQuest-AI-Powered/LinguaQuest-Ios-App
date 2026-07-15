//
//  WelcomeStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

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

                Text("""
                Learn languages by
                exploring the \(Text("real world!")
                    .foregroundStyle(Color("PrimaryColor")))
                """)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)


                Spacer()

                VStack(spacing: 12) {
                    CustomButton(
                        type: .primary,
                        text: "Get Started",
                        action: onGetStarted
                    )

                    CustomButton(
                        type: .secendry,
                        text: "I already have an account",
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
