//
//  OnboardingViewModel.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation

@Observable
@MainActor
final class OnboardingViewModel {
    private(set) var state = OnboardingUiState()

    func onGetStartedTapped() {
        state.currentStep = .language
    }

    func onSpokenLanguageSelected(_ language: Language) {
        state.selectedSpokenLanguage = language
    }

    func onLearningLanguageSelected(_ language: Language) {
        state.selectedLearningLanguage = language
    }

    func onLanguageContinueTapped() {
        guard state.canContinueFromLanguage else { return }
        state.currentStep = .level
    }

    func onLevelSelected(_ level: UserLevel) {
        state.selectedLevel = level
    }

    func onFinishTapped() {
        guard state.canContinueFromLevel else { return }
        // Save onboarding completion / navigate to app
    }

    func onLoginTapped() {
        // Navigate to sign in
    }
}
