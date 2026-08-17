//
//  OnboardingViewModel.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    private(set) var state = OnboardingUiState()
    private var userPreferences: UserPreferencesProtocol
    private let router: RouterProtocol

    init(router: RouterProtocol, userPreferences: UserPreferencesProtocol) {
        self.router = router
        self.userPreferences = userPreferences
    }

    func onGetStartedTapped() {
        state.currentStep = .language
    }

    func onBackTapped() {
        switch state.currentStep {
        case .welcome:
            router.pop()
        case .language:
            state.currentStep = .welcome
        case .level:
            state.currentStep = .language
        }
    }

    func onSpokenLanguageSelected(_ language: AppLanguage) {
        state.selectedSpokenLanguage = language
        userPreferences.appLanguage = language.code
    }

    func onLearningLanguageSelected(_ language: AvailableLanguage) {
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
        router.push(.signUp)
    }

    func onLoginTapped() {
        userPreferences.isOnboardingCompleted = true
    }
}
