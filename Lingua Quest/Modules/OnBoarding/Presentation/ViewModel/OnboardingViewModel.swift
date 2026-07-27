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
    private let getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase

    init(router: RouterProtocol, userPreferences: UserPreferencesProtocol, getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase) {
        self.router = router
        self.userPreferences = userPreferences
        self.getAvailableLanguagesUseCase = getAvailableLanguagesUseCase
    }

    func onGetStartedTapped() {
        state.currentStep = .language
        fetchTargetLanguages()
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
    }

    func onLearningLanguageSelected(_ language: AvailableLanguage) {
        state.selectedLearningLanguage = language
    }

    private func fetchTargetLanguages() {
        guard state.targetLanguages.isEmpty else { return }
        state.isLoadingTargetLanguages = true
        Task {
            do {
                let languages = try await getAvailableLanguagesUseCase.execute()
                await MainActor.run {
                    self.state.targetLanguages = languages
                    self.state.isLoadingTargetLanguages = false
                }
            } catch {
                await MainActor.run {
                    self.state.isLoadingTargetLanguages = false
                    // Handle error if necessary
                }
            }
        }
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
        userPreferences.isOnboardingCompleted = true
    }
}
