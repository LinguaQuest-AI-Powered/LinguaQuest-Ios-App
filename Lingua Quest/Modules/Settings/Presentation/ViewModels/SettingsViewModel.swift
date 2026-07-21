//
//  SettingsViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation

@Observable
final class SettingsViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - User Data
    var userName: String = "Explorer Alex"
    
    // MARK: - App Experience Toggles
    var appLanguage: String = "English"
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var soundEffectsEnabled: Bool = true
    
    // MARK: - Account & Journey Data
    var learningLanguage: String = "English"
    
    // MARK: - Intentions (Methods)
    
    func logOut() {
        // Clear session & navigate to auth flow
    }
    
    func onBackTapped() {
        router.pop()
    }
}
