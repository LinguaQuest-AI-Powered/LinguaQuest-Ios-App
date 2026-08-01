//
//  MindReaderIntroViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MindReaderIntroViewModel {
    private let router: RouterProtocol
    let statsService: StatsService
    private let coordinator: MindReaderGameCoordinator

    var showReadyDialog = false
    var isLoadingGame = false
    
    var currentCategoryName: String {
        coordinator.availableWorlds.first?.name ?? "Kitchen"
    }
    
    var selectedWorldId: String {
        coordinator.availableWorlds.first?.id ?? "kitchen"
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
    
    func onAppear() {
        Task {
            try? await statsService.fetchStats()
            await coordinator.loadWorlds()
        }
    }
    
    func onStartGameTapped() {
        showReadyDialog = true
    }
    
    func onChangeCategoryTapped() {
        // Category change - future enhancement
    }
    
    func onNotYetTapped() {
        showReadyDialog = false
    }
    
    func onYesLetsGoTapped() {
        showReadyDialog = false
        isLoadingGame = true
        
        Task {
            await coordinator.initializeGame(worldId: selectedWorldId)
            isLoadingGame = false
            router.push(.mindReaderGame)
        }
    }
    
    func goBack() {
        router.pop()
    }
}

// MARK: - Preview Helper
extension MindReaderIntroViewModel {
    @MainActor
    static var preview: MindReaderIntroViewModel {
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
        return MindReaderIntroViewModel(router: MockRouter(), statsService: statsService, coordinator: coordinator)
    }
}
