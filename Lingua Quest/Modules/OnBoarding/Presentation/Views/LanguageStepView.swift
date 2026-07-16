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
                .appTextStyle(.headline,color: .black)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(L10n.Onboarding.languageStepSubtitle)
                .appTextStyle(.subtitle, color: .secondaryButtonText)
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
                borderColor: Color.appPrimary,
                action: {
                    showLearningLanguageSheet = true
                }
            )


            Spacer()

            CustomButton(
                type: .primary,
                text: L10n.Onboarding.commonContinue,
                action: onContinue,
                status: state.canContinueFromLanguage ? .enable : .disable,
                trailing: Image(systemIcon: .arrowRight),
                disabledAction: { showAlert = true }
            )
        }
        .padding(24)
        .background(Color(.systemBackground))
        .alert(L10n.Onboarding.alertErrorTitle, isPresented: $showAlert) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            Text(L10n.Onboarding.alertLanguageMessage)
        }
        .sheet(isPresented: $showSpokenLanguageSheet) {
            LanguagePickerSheet(
                languages: state.availableLanguages,
                onSelect: onSelectSpokenLanguage
            )
        }
        .sheet(isPresented: $showLearningLanguageSheet) {
            LanguagePickerSheet(
                languages: state.availableLanguages,
                onSelect: onSelectLearningLanguage
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



#Preview {
    LanguageStepView(
        state: OnboardingUiState(),
        onSelectSpokenLanguage: { _ in },
        onSelectLearningLanguage: { _ in },
        onContinue: { }
    )
}
