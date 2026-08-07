//
//  LanguageStepView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguageStepView: View {
    let state: OnboardingUiState
    let onSelectSpokenLanguage: (AppLanguage) -> Void
    let onSelectLearningLanguage: (AvailableLanguage) -> Void
    let onContinue: () -> Void
    var onBack: (() -> Void)? = nil

    @State private var showSpokenLanguageSheet = false
    @State private var showLearningLanguageSheet = false
    @State private var showAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let onBack {
                HStack {
                    CustomBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
            
            VStack(alignment: .leading, spacing: 24) {
            LoopedVideoPlayerView(videoAsset: .welcome)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)

            VStack(spacing: 8) {
                Text(L10n.Onboarding.languageStepTitle)
                    .appTextStyle(.displaySmall, color: .appTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(L10n.Onboarding.languageStepSubtitle)
                    .appTextStyle(.bodyLarge, color: .appTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            VStack(spacing: 16) {
                LanguageSelectorButton(
                    title: L10n.Onboarding.languageSelectorISpeak,
                    placeholder: L10n.Onboarding.languageSelectorPlaceholder,
                    selectedName: state.selectedSpokenLanguage?.name,
                    selectedFlag: state.selectedSpokenLanguage?.flag,
                    action: {
                        showSpokenLanguageSheet = true
                    }
                )

                LanguageSelectorButton(
                    title: L10n.Onboarding.languageStepIWantToLearn,
                    placeholder: L10n.Onboarding.languageSelectorPlaceholder,
                    selectedName: state.selectedLearningLanguage?.name,
                    selectedFlag: state.selectedLearningLanguage?.flagEmoji,
                    action: {
                        showLearningLanguageSheet = true
                    }
                )
            }

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
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .alert(L10n.Onboarding.alertErrorTitle, isPresented: $showAlert) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            Text(L10n.Onboarding.alertLanguageMessage)
        }
        .customBottomSheet(isPresented: $showSpokenLanguageSheet) {
            LanguagePickerSheet(
                languages: state.nativeLanguages,
                namePath: { $0.name },
                flagPath: { $0.flag },
                onSelect: onSelectSpokenLanguage,
                isPresented: $showSpokenLanguageSheet
            )
        }
        .customBottomSheet(isPresented: $showLearningLanguageSheet) {
            Group {
                if state.isLoadingTargetLanguages {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(.appBrandPrimary)
                        Spacer()
                    }
                    .frame(height: 300)
                } else if state.targetLanguages.isEmpty {
                    VStack {
                        Spacer()
                        Text(L10n.Common.error)
                            .appTextStyle(.bodyLarge, color: .appTextSecondary)
                        Spacer()
                    }
                    .frame(height: 300)
                } else {
                    LanguagePickerSheet(
                        languages: state.targetLanguages,
                        namePath: { $0.name },
                        flagPath: { $0.flagEmoji },
                        onSelect: onSelectLearningLanguage,
                        isPresented: $showLearningLanguageSheet
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
