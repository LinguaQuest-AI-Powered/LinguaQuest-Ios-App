//
//  OnboardingUiState.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation

//TODO: change hard coded texts
struct OnboardingUiState {
    var currentStep: OnboardingStep = .welcome
    var selectedLevel: UserLevel?
    var selectedSpokenLanguage: Language?
    var selectedLearningLanguage: Language?
    
    var availableLanguages: [Language] = [
        Language(name: "English", flag: .english),
        Language(name: "Spanish", flag: .spanish),
        Language(name: "French", flag: .french),
        Language(name: "German", flag: .german),
        Language(name: "Japanese", flag: .japanese)
    ]
    
    var canContinueFromLanguage: Bool {
        selectedSpokenLanguage != nil && selectedLearningLanguage != nil
    }

    var canContinueFromLevel: Bool {
        selectedLevel != nil
    }
}
