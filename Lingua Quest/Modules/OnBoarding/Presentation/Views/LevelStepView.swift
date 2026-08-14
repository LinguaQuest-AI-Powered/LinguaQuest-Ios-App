//
//  LevelStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LevelStepView: View {
    let state: OnboardingUiState
    let onSelectLevel: (UserLevel) -> Void
    let onContinue: () -> Void
    var onBack: (() -> Void)? = nil
    @State private var showAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.appAccentOrange.opacity(0.2))
                                .blur(radius: 60)
                                .frame(width: 350, height: 300)
                                .offset(y: -30)
                            
                            Image(asset: .resetPasswordBird)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 270)
                              
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                        
                        VStack(spacing: 20) {
                            Text(L10n.Onboarding.levelStepTitle)
                                .appTextStyle(.displaySmall,color: .appTextPrimary)
                              
                            Text(L10n.Onboarding.levelStepSubtitle)
                                .appTextStyle(.bodyLarge, color: .appTextSecondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appSurfaceCard)
                                ).overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            Color.appBorderLight ,
                                            lineWidth: 1
                                        )
                                )
                            
                            VStack(spacing: 14) {
                                ForEach(UserLevel.allCases) { level in
                                    LevelCard(
                                        level: level,
                                        isSelected: state.selectedLevel == level,
                                        action: { onSelectLevel(level) }
                                    )
                                }
                            }
                        }
                        .padding(.top, -40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                VStack {
                    CustomButton(
                        type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                        text: L10n.Onboarding.commonContinue,
                        action: onContinue,
                        status: state.canContinueFromLevel ? .enable : .disable,
                        trailing: Image(systemIcon: .arrowRight),
                        disabledAction: { showAlert = true }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .ignoresSafeArea(edges: .top)
            
            if let onBack {
                HStack {
                    CustomBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
        .alert(L10n.Onboarding.alertErrorTitle, isPresented: $showAlert) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            Text(L10n.Onboarding.alertLevelMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("LightTheme") {
    LevelStepView(
        state: OnboardingUiState(),
        onSelectLevel: { _ in },
        onContinue: {}
    )

}

#Preview("DarkTheme") {
    LevelStepView(
        state: OnboardingUiState(),
        onSelectLevel: { _ in },
        onContinue: {}
    )
    .preferredColorScheme(.dark)
}
