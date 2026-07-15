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
    private var userPreferences: UserPreferencesProtocol

    init(userPreferences: UserPreferencesProtocol? = nil) {
        self.userPreferences = userPreferences ?? Resolver.shared.resolve(UserPreferencesProtocol.self)
    }

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
        userPreferences.spokenLanguageCode = state.selectedSpokenLanguage?.code
        userPreferences.learningLanguageCode = state.selectedLearningLanguage?.code
        userPreferences.userLevel = state.selectedLevel?.rawValue
        userPreferences.isOnboardingCompleted = true
    }

    func onLoginTapped() {
        // Navigate to sign in
    }
}
