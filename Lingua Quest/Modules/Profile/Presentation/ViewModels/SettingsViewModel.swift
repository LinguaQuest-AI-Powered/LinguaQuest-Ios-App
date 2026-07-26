//
//  SettingsViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let sessionManager: SessionManagerProtocol
    private let statsService: StatsService
    private let activateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol?
    let languageViewModel: LanguageViewModel
    private let userPreferences: UserPreferences

    init(
        router: RouterProtocol,
        sessionManager: SessionManagerProtocol,
        statsService: StatsService,
        activateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol? = nil,
        languageViewModel: LanguageViewModel,
        userPreferences: UserPreferences
    ) {
        self.router = router
        self.sessionManager = sessionManager
        self.statsService = statsService
        self.activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase
        self.languageViewModel = languageViewModel
        self.userPreferences = userPreferences
    }
    
    // MARK: - User Data
    var userName: String = L10n.Settings.explorerName(AppConstants.Common.defaultUserName)
    
    // MARK: - App Experience Toggles
    var appLanguageCode: String = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en" {
        didSet {
            UserDefaults.standard.set(appLanguageCode, forKey: AppConstants.UserDefaultsKeys.appLanguage)
            appLanguage = appLanguageCode == "ar" ? "Arabic" : "English"
        }
    }
    
    var appLanguage: String = (UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en") == "ar" ? "Arabic" : "English"
    var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.notificationsEnabled) {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)
            handleNotificationsToggle()
        }
    }
    
    var darkModeEnabled: Bool = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode) {
        didSet {
            UserDefaults.standard.set(darkModeEnabled, forKey: AppConstants.UserDefaultsKeys.isDarkMode)
        }
    }
    var soundEffectsEnabled: Bool = true
    
    var isLockScreenVocabularyEnabled: Bool = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled) {
        didSet {
            handleLockScreenVocabularyToggle()
        }
    }
    
    // MARK: - Lock Screen Vocabulary State
    var showActivationDialog: Bool = false
    var activationState: ActivationState = .idle
    var showNotEnoughCoins: Bool = false
    var missingCoins: Int = 0
    
    // MARK: - Daily Reminder Toggles
    var dailyReminderEnabled: Bool = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.dailyReminderEnabled) {
        didSet {
            UserDefaults.standard.set(dailyReminderEnabled, forKey: AppConstants.UserDefaultsKeys.dailyReminderEnabled)
            updateNotificationSchedule()
        }
    }
    
    var reminderTime: Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: AppConstants.UserDefaultsKeys.reminderTime)) {
        didSet {
            UserDefaults.standard.set(reminderTime.timeIntervalSince1970, forKey: AppConstants.UserDefaultsKeys.reminderTime)
            updateNotificationSchedule()
        }
    }
    
    var reminderRepeatDays: [Int] = (UserDefaults.standard.array(forKey: AppConstants.UserDefaultsKeys.reminderRepeatDays) as? [Int]) ?? [1,2,3,4,5,6,7] {
        didSet {
            UserDefaults.standard.set(reminderRepeatDays, forKey: AppConstants.UserDefaultsKeys.reminderRepeatDays)
            updateNotificationSchedule()
        }
    }
    
    // MARK: - Toast State
    var showToast: Bool = false
    var toastType: AppToastType = .success
    var toastTitle: String = ""
    var toastSubtitle: String? = nil
    
    // MARK: - Account & Journey Data
    var learningLanguage: String {
        if let active = languageViewModel.activeLanguage {
            return active.name
        }
        return userPreferences.targetLanguageName ?? "English"
    }
    
    // MARK: - Intentions (Methods)
    
    private func handleNotificationsToggle() {
        if notificationsEnabled {
            Task {
                do {
                    let granted = try await LocalNotificationManager.shared.requestAuthorization()
                    DispatchQueue.main.async {
                        if granted {
                            self.showToast(title: L10n.Settings.notificationsEnabledToast, type: .success)
                            self.updateNotificationSchedule()
                        } else {
                            self.notificationsEnabled = false
                            // Optional: Show alert to open settings
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.notificationsEnabled = false
                    }
                }
            }
        } else {
            LocalNotificationManager.shared.cancelDailyReminder()
            showToast(title: "Notifications", subtitle: L10n.Settings.notificationsPausedToast, type: .info)
        }
    }
    
    private func handleLockScreenVocabularyToggle() {
        let isSavedAsEnabled = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
        
        if isLockScreenVocabularyEnabled && !isSavedAsEnabled {
            // Revert state temporarily until confirmed
            isLockScreenVocabularyEnabled = false
            showActivationDialog = true
        } else if !isLockScreenVocabularyEnabled && isSavedAsEnabled {
            // User disabled it
            UserDefaults.standard.set(false, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
            showToast(title: L10n.LockScreenVocabulary.toggleLabel, subtitle: L10n.LockScreenVocabulary.disabledToast, type: .info)
        }
    }
    
    func confirmActivation() {
        guard let activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase else { return }
        
        let currentBalance = statsService.coins
        let cost = AppConstants.Common.unlockVocabularyCost
        
        if currentBalance >= cost {
            activationState = .loading
            Task {
                let result = await activateLockScreenVocabularyUseCase.execute()
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.activationState = .success
                        UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
                        self.isLockScreenVocabularyEnabled = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.showActivationDialog = false
                            self.activationState = .idle
                        }
                    case .failure:
                        self.activationState = .failure
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.showActivationDialog = false
                            self.activationState = .idle
                        }
                    }
                }
            }
        } else {
            self.missingCoins = cost - currentBalance
            self.showNotEnoughCoins = true
        }
    }
    
    func updateNotificationSchedule() {
        guard notificationsEnabled, dailyReminderEnabled else {
            LocalNotificationManager.shared.cancelDailyReminder()
            return
        }
        
        Task {
            await LocalNotificationManager.shared.scheduleDailyReminder(time: reminderTime, repeatDays: reminderRepeatDays)
        }
    }
    
    private func showToast(title: String, subtitle: String? = nil, type: AppToastType) {
        self.toastTitle = title
        self.toastSubtitle = subtitle
        self.toastType = type
        self.showToast = true
    }
    
    func getRepeatDaysText() -> String {
        let allDays = [1,2,3,4,5,6,7]
        let weekdays = [2,3,4,5,6]
        let weekends = [1,7]
        
        let sortedDays = reminderRepeatDays.sorted()
        
        if sortedDays == allDays {
            return L10n.Settings.repeatEveryDay
        } else if sortedDays == weekdays {
            return L10n.Settings.repeatWeekdays
        } else if sortedDays == weekends {
            return L10n.Settings.repeatWeekends
        } else {
            return L10n.Settings.repeatCustom
        }
    }
    
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
