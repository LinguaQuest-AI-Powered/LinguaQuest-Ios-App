//
//  MindReaderGameViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation
import Combine

enum MindReaderBirdState {
    case normal
    case thinking
    case pointing
}

@MainActor
@Observable
final class MindReaderGameViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    
    // Progress Data
    var currentQuestionIndex = 20
    var totalQuestions = 20
    var progressPercentage: Int {
        Int((Double(currentQuestionIndex) / Double(totalQuestions)) * 100)
    }
    
    // Game Data
    var questionText = "¿SE ENCUENTRA EN LA COCINA?"
    var birdState: MindReaderBirdState = .normal
    
    // Disable buttons while processing
    var isProcessing = false
    
    init(router: RouterProtocol, statsService: StatsService) {
        self.router = router
        self.statsService = statsService
    }
    
    func onAnswerTapped(_ answer: String) {
        guard !isProcessing else { return }
        isProcessing = true
        
        // Show thinking state
        birdState = .thinking
        
        Task {
            // Fake delay for thinking
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            // Show pointing/success state (just as an example, logic will depend on actual engine)
            birdState = .pointing
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Advance question and go back to normal
            if currentQuestionIndex < totalQuestions {
                currentQuestionIndex += 1
                birdState = .normal
                isProcessing = false
            } else {
                // If this is the last question or we are forcing the guess:
                isProcessing = false
                router.push(.mindReaderGuess)
            }
        }
    }
    
    func onTranslateTapped() {
        // Translation logic
    }
    
    func onListenTapped() {
        // Text to speech logic
    }
    
    func goBack() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension MindReaderGameViewModel {
    @MainActor
    static var preview: MindReaderGameViewModel {
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
                return WalletResponseDTO(success: true, data: WalletDataDTO(xp: 500, coins: 100))
            }
            func adjustWallet(coinsDelta: Int, xpDelta: Int) async throws -> AdjustWalletResponseDTO {
                return AdjustWalletResponseDTO(success: true, data: AdjustWalletDataDTO(xpDelta: xpDelta, coinsDelta: coinsDelta, xp: 500, coins: 100))
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
            var coinBalance: Int = 100
            var xpBalance: Int = 500
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
        return MindReaderGameViewModel(router: MockRouter(), statsService: statsService)
    }
}
