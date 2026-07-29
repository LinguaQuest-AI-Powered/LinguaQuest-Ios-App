//
//  UserPreferences.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import Foundation
import SwiftUI
import Observation

protocol UserPreferencesProtocol: AnyObject {
    var userId: Int? { get set }
    var isOnboardingCompleted: Bool { get set }
    var isLoggedIn: Bool { get set }
    var needsProfileCompletion: Bool { get set }
    var spokenLanguageCode: String? { get set }
    var learningLanguageCode: String? { get set }
    var userLevel: String? { get set }
    var isDarkMode: Bool { get set }
    var appLanguage: String { get set }
    
    // Stats storage
    var coinBalance: Int { get set }
    var xpBalance: Int { get set }
    var streakDays: Int { get set }
    
    // Profile info
    var email: String? { get set }
    var nativeLanguageName: String? { get set }
    var targetLanguageName: String? { get set }
    
    var isLockScreenVocabularyEnabled: Bool { get set }
    
    func resetAll()
}

@Observable
final class UserPreferences: UserPreferencesProtocol {
    @ObservationIgnored private let defaults = UserDefaults.standard
    
    var userId: Int? {
        didSet {
            if let id = userId {
                defaults.set(id, forKey: "userId")
            } else {
                defaults.removeObject(forKey: "userId")
            }
        }
    }
    
    var isOnboardingCompleted: Bool {
        didSet { defaults.set(isOnboardingCompleted, forKey: AppConstants.UserDefaultsKeys.isOnboardingCompleted) }
    }
    
    var spokenLanguageCode: String? {
        didSet { defaults.set(spokenLanguageCode, forKey: AppConstants.UserDefaultsKeys.spokenLanguageCode) }
    }
    
    var learningLanguageCode: String? {
        didSet { defaults.set(learningLanguageCode, forKey: AppConstants.UserDefaultsKeys.learningLanguageCode) }
    }
    
    var userLevel: String? {
        didSet { defaults.set(userLevel, forKey: AppConstants.UserDefaultsKeys.userLevel) }
    }
    
    var isLoggedIn: Bool {
        didSet { defaults.set(isLoggedIn, forKey: AppConstants.UserDefaultsKeys.isLoggedIn) }
    }
    
    var needsProfileCompletion: Bool {
        didSet { defaults.set(needsProfileCompletion, forKey: AppConstants.UserDefaultsKeys.needsProfileCompletion) }
    }
    
    var isDarkMode: Bool {
        didSet { defaults.set(isDarkMode, forKey: AppConstants.UserDefaultsKeys.isDarkMode) }
    }
    
    var appLanguage: String {
        didSet { defaults.set(appLanguage, forKey: AppConstants.UserDefaultsKeys.appLanguage) }
    }
    
    var coinBalance: Int {
        didSet { defaults.set(coinBalance, forKey: AppConstants.UserDefaultsKeys.coinBalance) }
    }
    
    var xpBalance: Int {
        didSet { defaults.set(xpBalance, forKey: AppConstants.UserDefaultsKeys.xpBalance) }
    }
    
    var streakDays: Int {
        didSet { defaults.set(streakDays, forKey: AppConstants.UserDefaultsKeys.streakDays) }
    }
    
    var email: String? {
        didSet { defaults.set(email, forKey: AppConstants.UserDefaultsKeys.userEmail) }
    }
    
    var nativeLanguageName: String? {
        didSet { defaults.set(nativeLanguageName, forKey: AppConstants.UserDefaultsKeys.nativeLanguageName) }
    }
    
    var targetLanguageName: String? {
        didSet { defaults.set(targetLanguageName, forKey: AppConstants.UserDefaultsKeys.targetLanguageName) }
    }
    
    var isLockScreenVocabularyEnabled: Bool {
        didSet { defaults.set(isLockScreenVocabularyEnabled, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled) }
    }
    
    init() {
        if defaults.object(forKey: "userId") != nil {
            self.userId = defaults.integer(forKey: "userId")
        } else {
            self.userId = nil
        }
        self.isOnboardingCompleted = defaults.bool(forKey: AppConstants.UserDefaultsKeys.isOnboardingCompleted)
        self.spokenLanguageCode = defaults.string(forKey: AppConstants.UserDefaultsKeys.spokenLanguageCode)
        self.learningLanguageCode = defaults.string(forKey: AppConstants.UserDefaultsKeys.learningLanguageCode)
        self.userLevel = defaults.string(forKey: AppConstants.UserDefaultsKeys.userLevel)
        self.isLoggedIn = defaults.bool(forKey: AppConstants.UserDefaultsKeys.isLoggedIn)
        self.needsProfileCompletion = defaults.bool(forKey: AppConstants.UserDefaultsKeys.needsProfileCompletion)
        self.isDarkMode = defaults.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode)
        self.appLanguage = defaults.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        self.coinBalance = defaults.integer(forKey: AppConstants.UserDefaultsKeys.coinBalance)
        self.xpBalance = defaults.integer(forKey: AppConstants.UserDefaultsKeys.xpBalance)
        self.streakDays = defaults.integer(forKey: AppConstants.UserDefaultsKeys.streakDays)
        self.email = defaults.string(forKey: AppConstants.UserDefaultsKeys.userEmail)
        self.nativeLanguageName = defaults.string(forKey: AppConstants.UserDefaultsKeys.nativeLanguageName)
        self.targetLanguageName = defaults.string(forKey: AppConstants.UserDefaultsKeys.targetLanguageName)
        self.isLockScreenVocabularyEnabled = defaults.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
    }
    
    func resetAll() {
        userId = nil
        isOnboardingCompleted = false
        isLoggedIn = false
        needsProfileCompletion = false
        spokenLanguageCode = nil
        learningLanguageCode = nil
        userLevel = nil
        isDarkMode = false
        appLanguage = "en"
        coinBalance = 0
        xpBalance = 0
        streakDays = 0
        email = nil
        nativeLanguageName = nil
        targetLanguageName = nil
        isLockScreenVocabularyEnabled = false
        
        let keysToRemove = [
            AppConstants.UserDefaultsKeys.isOnboardingCompleted,
            AppConstants.UserDefaultsKeys.isLoggedIn,
            AppConstants.UserDefaultsKeys.needsProfileCompletion,
            AppConstants.UserDefaultsKeys.spokenLanguageCode,
            AppConstants.UserDefaultsKeys.learningLanguageCode,
            AppConstants.UserDefaultsKeys.userLevel,
            AppConstants.UserDefaultsKeys.isDarkMode,
            AppConstants.UserDefaultsKeys.appLanguage,
            AppConstants.UserDefaultsKeys.coinBalance,
            AppConstants.UserDefaultsKeys.xpBalance,
            AppConstants.UserDefaultsKeys.streakDays,
            AppConstants.UserDefaultsKeys.userEmail,
            AppConstants.UserDefaultsKeys.nativeLanguageName,
            AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled,
            AppConstants.UserDefaultsKeys.cachedAvatarUrl,
            AppConstants.UserDefaultsKeys.notificationsEnabled,
            AppConstants.UserDefaultsKeys.dailyReminderEnabled,
            AppConstants.UserDefaultsKeys.reminderTime,
            AppConstants.UserDefaultsKeys.reminderRepeatDays,
            "userId"
        ]
        
        for key in keysToRemove {
            defaults.removeObject(forKey: key)
        }
    }
}
