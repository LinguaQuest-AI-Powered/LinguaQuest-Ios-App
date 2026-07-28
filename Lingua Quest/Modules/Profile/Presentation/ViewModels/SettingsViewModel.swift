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
    private let lockScreenSettingsRemoteDataSource: LockScreenSettingsRemoteDataSourceProtocol?

    init(
        router: RouterProtocol,
        sessionManager: SessionManagerProtocol,
        statsService: StatsService,
        activateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol? = nil,
        languageViewModel: LanguageViewModel,
        userPreferences: UserPreferences,
        lockScreenSettingsRemoteDataSource: LockScreenSettingsRemoteDataSourceProtocol? = nil
    ) {
        self.router = router
        self.sessionManager = sessionManager
        self.statsService = statsService
        self.activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase
        self.languageViewModel = languageViewModel
        self.userPreferences = userPreferences
        self.lockScreenSettingsRemoteDataSource = lockScreenSettingsRemoteDataSource
    }
    
    // MARK: - User Data
    var userName: String = L10n.Settings.explorerName(AppConstants.Common.defaultUserName)
    
    // MARK: - App Experience Toggles
    var appLanguageCode: String = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en" {
        didSet {
            UserDefaults.standard.set(appLanguageCode, forKey: AppConstants.UserDefaultsKeys.appLanguage)
            appLanguage = AppLanguage(rawValue: appLanguageCode)?.name ?? "English"
        }
    }
    
    func refreshAppLanguage() {
        let savedCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        if savedCode != appLanguageCode {
            self.appLanguageCode = savedCode
        }
    }
    
    var appLanguage: String = AppLanguage(rawValue: UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en")?.name ?? "English"
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
    var currentCoins: Int = 0
    
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
        Task { @MainActor in
            let isSavedAsEnabled = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
            
            if self.isLockScreenVocabularyEnabled && !isSavedAsEnabled {
                // Temporarily revert UI toggle until logic completes
                self.isLockScreenVocabularyEnabled = false
                
                guard let userId = self.userPreferences.userId,
                      let remoteDS = self.lockScreenSettingsRemoteDataSource else {
                    self.showActivationDialog = true
                    return
                }
                
                self.activationState = .checking
                do {
                    let unlocked = try await remoteDS.isUnlocked(userId: userId)
                    self.activationState = .idle
                    if unlocked {
                        self.activateWithoutPayment()
                    } else {
                        self.showActivationDialog = true
                    }
                } catch {
                    self.activationState = .idle
                    self.showActivationDialog = true
                }
            } else if !self.isLockScreenVocabularyEnabled && isSavedAsEnabled {
                // User disabled it
                UserDefaults.standard.set(false, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
                self.showToast(title: L10n.LockScreenVocabulary.toggleLabel, subtitle: L10n.LockScreenVocabulary.disabledToast, type: .info)
            }
        }
    }
    
    private func activateWithoutPayment() {
        guard let activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase else { return }
        
        Task {
            let result = await activateLockScreenVocabularyUseCase.execute()
            await MainActor.run {
                switch result {
                case .success:
                    UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
                    self.isLockScreenVocabularyEnabled = true
                    self.showToast(title: L10n.LockScreenVocabulary.toggleLabel, subtitle: L10n.LockScreenVocabulary.activatedToast, type: .success)
                case .failure:
                    self.isLockScreenVocabularyEnabled = false
                    self.showToast(title: L10n.Common.error, type: .error)
                }
            }
        }
    }
    
    func confirmActivation() {
        guard let activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase else { return }
        
        let cost = AppConstants.Common.unlockVocabularyCost
        activationState = .loading
        
        Task {
            do {
                // Fetch the latest wallet balance from API
                try await statsService.fetchStats()
                let currentBalance = statsService.coins
                
                if currentBalance >= cost {
                    // 1. Deduct Coins via API
                    try await statsService.deductCoins(cost)
                    
                    // 2. Mark as unlocked in Firestore
                    if let userId = userPreferences.userId,
                       let remoteDS = lockScreenSettingsRemoteDataSource {
                        try await remoteDS.setUnlocked(userId: userId)
                    }
                    
                    // 3. Activate Use Case
                    let result = await activateLockScreenVocabularyUseCase.execute()
                    await MainActor.run {
                        switch result {
                        case .success:
                            UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.isLockScreenVocabularyEnabled)
                            self.isLockScreenVocabularyEnabled = true
                            self.showActivationDialog = false
                            self.activationState = .idle
                            self.showToast(title: L10n.LockScreenVocabulary.toggleLabel, subtitle: L10n.LockScreenVocabulary.activatedToast, type: .success)
                            
                        case .failure:
                            self.showActivationDialog = false
                            self.activationState = .idle
                            self.showToast(title: L10n.Common.error, type: .error)
                        }
                    }
                } else {
                    await MainActor.run {
                        self.currentCoins = currentBalance
                        self.missingCoins = cost - currentBalance
                        self.showActivationDialog = false // Hide payment dialog
                        self.showNotEnoughCoins = true
                        self.activationState = .idle
                    }
                }
            } catch {
                await MainActor.run {
                    self.activationState = .failure
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showActivationDialog = false
                        self.activationState = .idle
                        self.showToast(title: L10n.Common.error, subtitle: error.localizedDescription, type: .error)
                    }
                }
            }
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
    
    func onAppLanguageTapped() {
        router.push(.appLanguageSelection)
    }
    
    func onAboutTapped() {
        router.push(.about)
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

