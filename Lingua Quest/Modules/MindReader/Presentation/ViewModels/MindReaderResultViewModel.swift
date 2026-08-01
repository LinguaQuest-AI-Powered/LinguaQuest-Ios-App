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
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var earnedXP: Int {
        if case .victory(_, let xpEarned, _) = coordinator.trapResult {
            return xpEarned
        }
        return 0
    }
    
    var earnedCoins: Int {
        if case .victory(let coinsEarned, _, _) = coordinator.trapResult {
            return coinsEarned
        }
        return 0
    }
    
    var isStumpedBonus: Bool {
        if case .victory(_, _, let isStumped) = coordinator.trapResult {
            return isStumped
        }
        return false
    }
    
    var hasAwarded = false
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
    }
    
    /// Awards coins and XP on first appear, saves game result
    func onAppear() {
        guard !hasAwarded else { return }
        hasAwarded = true
        
        Task {
            // Award coins and XP via StatsService
            try? await statsService.adjustWallet(
                coinsDelta: earnedCoins,
                xpDelta: earnedXP
            )
            
            // Save result to repository
            await coordinator.saveResult()
        }
    }
    
    func onPlayAgainTapped() {
        coordinator.reset()
        router.pop(count: 4)
    }
    
    func onBackToMenuTapped() {
        coordinator.reset()
        router.popToRoot()
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
        class MockRepo: MindReaderRepositoryProtocol {
            func getWorlds() async throws -> [MindReaderWorld] { [] }
            func getMatrixForWorld(worldId: String) async throws -> (words: [MindReaderWord], attributes: [QuestionAttribute]) { ([], []) }
            func saveGameResult(worldId: String, result: TrapValidationResult) async throws {}
        }
        class MockSoundPlayer: AppSoundPlayer {
            func play(sound: AppSound) {}
        }
        let statsService = StatsService(remoteDataSource: MockStatsRemote(), userPreferences: MockUserPrefs(), soundPlayer: MockSoundPlayer())
        let coordinator = MindReaderGameCoordinator(
            initializeGameUseCase: InitializeGameUseCase(repository: MockRepo()),
            calculateNextQuestionUseCase: CalculateNextQuestionUseCase(),
            processUserAnswerUseCase: ProcessUserAnswerUseCase(),
            validateHonestyUseCase: ValidateHonestyUseCase(),
            repository: MockRepo()
        )
        return MindReaderResultViewModel(router: MockRouter(), statsService: statsService, coordinator: coordinator)
    }
}
