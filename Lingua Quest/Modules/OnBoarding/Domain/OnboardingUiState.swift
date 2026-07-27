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
    var selectedSpokenLanguage: AppLanguage?
    var selectedLearningLanguage: AvailableLanguage?
    
    var nativeLanguages: [AppLanguage] = AppLanguage.allCases
    var targetLanguages: [AvailableLanguage] = []
    var isLoadingTargetLanguages: Bool = false
    
    var canContinueFromLanguage: Bool {
        selectedSpokenLanguage != nil && selectedLearningLanguage != nil
    }

    var canContinueFromLevel: Bool {
        selectedLevel != nil
    }
}
