//
//  AppConstants.swift
//  Lingua Quest
//
//  Created by siam on 16/07/2026.
//

import Foundation

enum AppConstants {
    enum UserDefaultsKeys {
        static let isOnboardingCompleted = "isOnboardingCompleted"
        static let isLoggedIn = "isLoggedIn"
        static let needsProfileCompletion = "needsProfileCompletion"
        static let spokenLanguageCode = "spokenLanguageCode"
        static let learningLanguageCode = "learningLanguageCode"
        static let userLevel = "userLevel"
        static let isDarkMode = "isDarkMode"
        static let appLanguage = "appLanguage"
        static let cachedAvatarUrl = "cachedAvatarUrl"
        
        static let notificationsEnabled = "notificationsEnabled"
        static let dailyReminderEnabled = "dailyReminderEnabled"
        static let reminderTime = "reminderTime"
        static let reminderRepeatDays = "reminderRepeatDays"
        static let coinBalance = "coinBalance"
        static let xpBalance = "xpBalance"
        static let streakDays = "streakDays"
        static let userEmail = "userEmail"
        static let nativeLanguageName = "nativeLanguageName"
        static let targetLanguageName = "targetLanguageName"
        static let isLockScreenVocabularyEnabled = "isLockScreenVocabularyEnabled"

    }
    enum Common {
        static let defaultUserName = "Alex"
        static let targetLanguageValue = "ar"
        static let noOfWorldGeneratedInAiLockScreen = 5
        static let unlockVocabularyCost = 0
        static let changeWordCost = 50
    }
} 
