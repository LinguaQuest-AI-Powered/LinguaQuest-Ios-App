//
//  MindReaderTranslationViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderTranslationViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator
    
    // MARK: - Computed Properties (from Coordinator)
    
    var wordToTranslate: String {
        coordinator.popQuiz?.targetWord.wordTargetLanguage ?? ""
    }
    
    var options: [String] {
        coordinator.popQuiz?.options ?? []
    }
    
    init(
        router: RouterProtocol,
        statsService: StatsService,
        coordinator: MindReaderGameCoordinator
    ) {
        self.router = router
        self.statsService = statsService
        self.coordinator = coordinator
    }
    
    func onOptionTapped(_ option: String) {
        let result = coordinator.validatePopQuiz(selectedOption: option)
        
        switch result {
        case .victory:
            router.push(.mindReaderResult)
        case .busted:
            router.push(.mindReaderFailure)
        }
    }
    
    func goBack() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension MindReaderTranslationViewModel {
    @MainActor
    static var preview: MindReaderTranslationViewModel {
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
        return MindReaderTranslationViewModel(router: MockRouter(), statsService: statsService, coordinator: coordinator)
    }
}
