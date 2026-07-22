//
//  ProfileCompletionViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileCompletionViewModel {
    private(set) var state = OnboardingUiState()
    private var userPreferences: UserPreferencesProtocol
    private let router: RouterProtocol

    init(router: RouterProtocol, userPreferences: UserPreferencesProtocol) {
        self.router = router
        self.userPreferences = userPreferences
        // Skip welcome step, go straight to language selection
        self.state.currentStep = .language
    }

    func onBackTapped() {
        switch state.currentStep {
        case .welcome, .language:
            if userPreferences.isLoggedIn {
                // If we are logged in but don't want to complete profile right now,
                // we technically shouldn't allow back to bypass the block, but if we do,
                // we should clear the login state so they aren't stuck on a blank/broken screen.
                // However, a better UX is just to log them out or pop to root.
                // For safety, let's pop to root (Login) and clear session via SessionManager 
                // but since we don't have SessionManager here, we just pop.
                router.popToRoot() 
            } else {
                router.pop()
            }
        case .level:
            state.currentStep = .language
        }
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
        
        if userPreferences.isLoggedIn {
            // Post-Auth (OAuth new user)
            // Just clear the flag, and the RootView state machine will auto-swap to Home
            userPreferences.needsProfileCompletion = false
        } else {
            // Pre-Registration (skipped onboarding)
            // Replace current view with SignUp
            router.pushAndReplace(.signUp)
        }
    }
}
