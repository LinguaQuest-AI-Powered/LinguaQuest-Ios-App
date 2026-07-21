//
//  SettingsViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let sessionManager: SessionManagerProtocol

    init(router: RouterProtocol, sessionManager: SessionManagerProtocol) {
        self.router = router
        self.sessionManager = sessionManager
    }
    
    // MARK: - User Data
    var userName: String = "Explorer Alex"
    
    // MARK: - App Experience Toggles
    var appLanguageCode: String = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en" {
        didSet {
            UserDefaults.standard.set(appLanguageCode, forKey: AppConstants.UserDefaultsKeys.appLanguage)
            appLanguage = appLanguageCode == "ar" ? "Arabic" : "English"
        }
    }
    
    var appLanguage: String = (UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en") == "ar" ? "Arabic" : "English"
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode) {
        didSet {
            UserDefaults.standard.set(darkModeEnabled, forKey: AppConstants.UserDefaultsKeys.isDarkMode)
        }
    }
    var soundEffectsEnabled: Bool = true
    
    // MARK: - Account & Journey Data
    var learningLanguage: String = "English"
    
    // MARK: - Intentions (Methods)
    
    func onEditProfileTapped() {
        router.push(.editProfile)
    }
    
    func logOut() {
        Task {
            await sessionManager.logout(allDevices: false)
        }
    }
    
    func onBackTapped() {
        router.pop()
    }
}
