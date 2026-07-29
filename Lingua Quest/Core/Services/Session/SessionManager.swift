//
//  SessionManager.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 20/07/2026.
//

import Foundation
import ActivityKit

protocol SessionManagerProtocol {
    /// User-initiated logout: calls the backend, then always clears local state and navigates to Login.
    func logout(allDevices: Bool) async
}

/// Central place that reacts to both user-initiated logout AND silent session expiry
/// (posted by AuthTokenProvider when a refresh fails), so both paths converge on the
/// same cleanup: clear tokens, flip isLoggedIn, and reset navigation to Login.
final class SessionManager: SessionManagerProtocol {
    private let router: RouterProtocol
    private let tokenStorage: SecureTokenStorageProtocol
    private var userPreferences: UserPreferencesProtocol
    private let statsService: StatsServiceProtocol
    private let logoutUseCase: LogoutUseCaseProtocol

    init(
        router: RouterProtocol,
        tokenStorage: SecureTokenStorageProtocol,
        userPreferences: UserPreferencesProtocol,
        statsService: StatsServiceProtocol,
        logoutUseCase: LogoutUseCaseProtocol
    ) {
        self.router = router
        self.tokenStorage = tokenStorage
        self.userPreferences = userPreferences
        self.statsService = statsService
        self.logoutUseCase = logoutUseCase

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionExpired),
            name: .sessionExpired,
            object: nil
        )
    }

    func logout(allDevices: Bool) async {
        let refreshToken = tokenStorage.getRefreshToken() ?? ""
        _ = await logoutUseCase.execute(refreshToken: refreshToken, allDevices: allDevices)
        await endLocalSession()
    }

    @objc private func handleSessionExpired() {
        Task { await endLocalSession() }
    }

    @MainActor
    private func endLocalSession() async {
        tokenStorage.clearSession()
        userPreferences.resetAll()
        statsService.resetAll()
        
        // Clear scheduled notifications
        LocalNotificationManager.shared.cancelDailyReminder()
        
        // Teardown Live Activities
        if #available(iOS 16.2, *) {
            for activity in Activity<WordWidgetAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
        
        router.popToRoot()
    }
}
