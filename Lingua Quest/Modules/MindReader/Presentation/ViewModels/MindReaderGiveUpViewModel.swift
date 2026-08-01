//
//  MindReaderGiveUpViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import Foundation
import Observation
import SwiftUI

// Mock Struct for the dropdown items
struct GiveUpWordMock: Hashable {
    let text: String
    let icon: Image.SystemIcon
}

@MainActor
@Observable
final class MindReaderGiveUpViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    
    let categoryName = "Kitchen"
    
    // Simulated list of words
    let availableWords: [GiveUpWordMock] = [
        GiveUpWordMock(text: "Spoon", icon: .sparkles), // Placeholder icons from your enum
        GiveUpWordMock(text: "Oven", icon: .flameFill),
        GiveUpWordMock(text: "Refrigerator", icon: .moonFill)
    ]
    
    // State for the selected word
    var selectedWord: GiveUpWordMock? = nil
    
    init(router: RouterProtocol, statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func selectWord(_ word: GiveUpWordMock) {
        selectedWord = word
    }
    
    func onSubmitTapped() {
        guard selectedWord != nil else { return }
        router.pop(count: 3)
    }
    
    func onBackToMenuTapped() {
        router.popToRoot()
    }
    
    func goBack() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension MindReaderGiveUpViewModel {
    @MainActor
    static var preview: MindReaderGiveUpViewModel {
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
                return WalletResponseDTO(success: true, data: WalletDataDTO(xp: 4500, coins: 1250))
            }
            func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws -> AdjustWalletResponseDTO {
                return AdjustWalletResponseDTO(success: true, data: AdjustWalletDataDTO(xpDelta: xpDelta, coinsDelta: coinsDelta, xp: 4500, coins: 1250))
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
            var coinBalance: Int = 1250
            var xpBalance: Int = 4500
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
        return MindReaderGiveUpViewModel(router: MockRouter(), statsService: statsService)
    }
}
