//
//  LanguageStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguageStepView: View {
    let state: OnboardingUiState
    let onSelectSpokenLanguage: (Language) -> Void
    let onSelectLearningLanguage: (Language) -> Void
    let onContinue: () -> Void
    var onBack: (() -> Void)? = nil

    @State private var showSpokenLanguageSheet = false
    @State private var showLearningLanguageSheet = false
    @State private var showAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(asset: .bird3)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .frame(maxWidth: .infinity)

            Text(L10n.Onboarding.languageStepTitle)
                .appTextStyle(.displaySmall,color: .appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(L10n.Onboarding.languageStepSubtitle)
                .appTextStyle(.bodyLarge, color: .appTextSecondary)
                .frame(maxWidth: .infinity, alignment: .center)

            LanguageSelectorButton(
                title: L10n.Onboarding.languageSelectorISpeak,
                placeholder: L10n.Onboarding.languageSelectorPlaceholder,
                selectedLanguage: state.selectedSpokenLanguage,
                borderColor: Color.gray.opacity(0.15),
                action: {
                    showSpokenLanguageSheet = true
                }
            )

            LanguageSelectorButton(
                title: L10n.Onboarding.languageStepIWantToLearn,
                placeholder: L10n.Onboarding.languageSelectorPlaceholder,
                selectedLanguage: state.selectedLearningLanguage,
                borderColor: Color.appBrandPrimary,
                action: {
                    showLearningLanguageSheet = true
                }
            )


            Spacer()

            CustomButton(
                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrown),
                text: L10n.Onboarding.commonContinue,
                action: onContinue,
                status: state.canContinueFromLanguage ? .enable : .disable,
                trailing: Image(systemIcon: .arrowRight),
                disabledAction: { showAlert = true }
            )
        }
        .padding(24)
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .alert(L10n.Onboarding.alertErrorTitle, isPresented: $showAlert) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            Text(L10n.Onboarding.alertLanguageMessage)
        }
        .customBottomSheet(isPresented: $showSpokenLanguageSheet) {
            LanguagePickerSheet(
                languages: state.availableLanguages,
                onSelect: onSelectSpokenLanguage,
                isPresented: $showSpokenLanguageSheet
            )
        }
        .customBottomSheet(isPresented: $showLearningLanguageSheet) {
            LanguagePickerSheet(
                languages: state.availableLanguages,
                onSelect: onSelectLearningLanguage,
                isPresented: $showLearningLanguageSheet
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let onBack {
                    CustomBackButton(action: onBack)
                }
            }
        }
    }
}

#Preview("LightTheme") {
    LanguageStepView(
        state: OnboardingUiState(),
        onSelectSpokenLanguage: { _ in },
        onSelectLearningLanguage: { _ in },
        onContinue: { }
    )
}

#Preview("DarkTheme") {
    LanguageStepView(
        state: OnboardingUiState(),
        onSelectSpokenLanguage: { _ in },
        onSelectLearningLanguage: { _ in },
        onContinue: { }
    )
    .preferredColorScheme(.dark)
}
