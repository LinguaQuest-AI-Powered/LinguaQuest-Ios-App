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
    
    var availableLanguages: [Language] = Language.allGlobalLanguages
    
    var canContinueFromLanguage: Bool {
        selectedSpokenLanguage != nil && selectedLearningLanguage != nil
    }

    var canContinueFromLevel: Bool {
        selectedLevel != nil
    }
}
