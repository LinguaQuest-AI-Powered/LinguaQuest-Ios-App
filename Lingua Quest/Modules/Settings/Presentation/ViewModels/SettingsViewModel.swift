//
//  SettingsViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation

@Observable
final class SettingsViewModel {
    // MARK: - User Data
    var userName: String = "Explorer Alex"
    
    // MARK: - App Experience Toggles
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var soundEffectsEnabled: Bool = true
    
    // MARK: - Account & Journey Data
    var learningLanguage: String = "Spanish"
    var dailyGoal: String = "15 mins"
    var learningStreak: String = "12 Days"
    
    // MARK: - Intentions (Methods)
    func saveChanges() {
        // Persist settings (API call / local storage)
    }
    
    func logOut() {
        // Clear session & navigate to auth flow
    }
}
