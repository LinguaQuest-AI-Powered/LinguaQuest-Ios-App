//
//  OnboardingUiState.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation

struct OnboardingUiState {
    var currentStep: OnboardingStep = .welcome
    var selectedLevel: UserLevel?
    var selectedSpokenLanguage: Language?
    var selectedLearningLanguage: Language?
    
    var availableLanguages: [Language] = [
        Language(code: "en", name: L10n.Onboarding.languageEnglish, flag: .english),
        Language(code: "es", name: L10n.Onboarding.languageSpanish, flag: .spanish),
        Language(code: "fr", name: L10n.Onboarding.languageFrench, flag: .french),
        Language(code: "de", name: L10n.Onboarding.languageGerman, flag: .german),
        Language(code: "ja", name: L10n.Onboarding.languageJapanese, flag: .japanese)
    ]
    
    var canContinueFromLanguage: Bool {
        selectedSpokenLanguage != nil && selectedLearningLanguage != nil
    }

    var canContinueFromLevel: Bool {
        selectedLevel != nil
    }
}
