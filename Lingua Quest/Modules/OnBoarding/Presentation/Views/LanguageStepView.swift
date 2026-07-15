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

    @State private var showSpokenLanguageSheet = false
    @State private var showLearningLanguageSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(asset: .bird3)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .frame(maxWidth: .infinity)

            Text("Choose your languages")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)

            Text("Let's set up your learning journey!")
                .font(.system(size: 18))
                .foregroundColor(Color("SecondaryButtonText"))
                .frame(maxWidth: .infinity, alignment: .center)

            LanguageSelectorButton(
                title: "I SPEAK...",
                placeholder: "Select language",
                selectedLanguage: state.selectedSpokenLanguage,
                borderColor: Color.gray.opacity(0.15),
                action: {
                    showSpokenLanguageSheet = true
                }
            )

            LanguageSelectorButton(
                title: "I WANT TO LEARN...",
                placeholder: "Select language",
                selectedLanguage: state.selectedLearningLanguage,
                borderColor: Color("AppPrimaryColor"),
                action: {
                    showLearningLanguageSheet = true
                }
            )


            Spacer()

            CustomButton(
                type: .primary,
                text: "Continue",
                action: onContinue,
                status: state.canContinueFromLanguage ? .enable : .disable,
                trailing: Image(systemName: "arrow.right")
            )
        }
        .padding(24)
        .background(Color(.systemBackground))
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
