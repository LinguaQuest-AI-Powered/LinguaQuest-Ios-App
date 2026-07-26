//
//  AppConstants.swift
//  Lingua Quest
//
//  Created by siam on 16/07/2026.
//

import Foundation

enum AppConstants {

    enum BossLevel {
        static let sessionDurationSeconds = 120
        static let silenceDurationSeconds: Double = 1.0
        static let silenceSampleRate = 16_000
        static let silenceBytesPerSample = 2
        static let silenceChunkSize = 3_200
        static let fluencyScoreFormat = "%d%%"
    }

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
    }
}
