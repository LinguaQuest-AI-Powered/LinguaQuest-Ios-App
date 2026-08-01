//
//  MindReaderResultViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderResultViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    
    // Example properties for rewards
    let earnedXP: Int = 50
    let earnedCoins: Int = 10
    
    init(router: RouterProtocol, statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func onPlayAgainTapped() {
        // Route back to the intro or restart the game
        // router.pop(count: 2) or router.pushAndReplace(.mindReaderIntro)
    }
    
    func onBackToMenuTapped() {
        // Route back to the main lobby/home
        // router.popToRoot()
    }
    
    func goBack() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension MindReaderResultViewModel {
    @MainActor
    static var preview: MindReaderResultViewModel {
        class MockRouter: RouterProtocol {
            func push(_ route: AppRoute) {}
            func pushAndReplace(_ route: AppRoute) {}
            func pushAndRemoveAll(_ route: AppRoute) {}
            func pop() {}
            func pop(count: Int) {}
            func popToRoot() {}
            func present(_ sheet: AppSheet) {}
            func dismissSheet() {}
        }
        class MockStatsRemote: StatsRemoteDataSourceProtocol {
            func getWallet() async throws -> WalletResponseDTO {
                return WalletResponseDTO(success: true, data: WalletDataDTO(xp: 550, coins: 110))
            }
            func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws -> AdjustWalletResponseDTO {
                return AdjustWalletResponseDTO(success: true, data: AdjustWalletDataDTO(xpDelta: xpDelta, coinsDelta: coinsDelta, xp: 550, coins: 110))
            }
        }
        class MockUserPrefs: UserPreferencesProtocol {
            var userId: Int? = 1
            var isOnboardingCompleted: Bool = true
            var isLoggedIn: Bool = true
            var needsProfileCompletion: Bool = false
            var spokenLanguageCode: String? = "en"
            var learningLanguageCode: String? = "es"
            var userLevel: String? = "beginner"
            var isDarkMode: Bool = false
            var appLanguage: String = "en"
            var coinBalance: Int = 110
            var xpBalance: Int = 550
            var streakDays: Int = 5
            var email: String? = "test@test.com"
            var nativeLanguageName: String? = "English"
            var targetLanguageName: String? = "Spanish"
            var isLockScreenVocabularyEnabled: Bool = false
            var isSoundEnabled: Bool = true
            var notificationsEnabled: Bool = true
            var dailyReminderEnabled: Bool = true
            var reminderTime: Double = 0
            var reminderRepeatDays: [Int] = []
            func resetSessionState() {}
            func loadUserScopedPreferences(for userId: Int) {}
        }
        let statsService = StatsService(remoteDataSource: MockStatsRemote(), userPreferences: MockUserPrefs())
        return MindReaderResultViewModel(router: MockRouter(), statsService: statsService)
    }
}
