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
    var selectedSpokenLanguage: AppLanguage? = AppLanguage(rawValue: UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en")
    var selectedLearningLanguage: AvailableLanguage?
    
    var nativeLanguages: [AppLanguage] = AppLanguage.allCases
    var targetLanguages: [AvailableLanguage] = AppLanguage.targetLanguages
    var isLoadingTargetLanguages: Bool = false
    
    var canContinueFromLanguage: Bool {
        selectedSpokenLanguage != nil && selectedLearningLanguage != nil
    }

    var canContinueFromLevel: Bool {
        selectedLevel != nil
    }
}
