//
//  MindReaderGameViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import Foundation
import Observation

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
    private let coordinator: MindReaderGameCoordinator
    
    // Translation lifeline cost
    let translateCost = 5
    
    // Bird animation state
    var birdState: MindReaderBirdState = .normal
    
    // Processing guard
    var isProcessing = false
    
    // Translation lifeline state
    var showTranslation = false
    var insufficientCoinsAlert = false
    var showTranslateConfirmDialog = false
    var showNotEnoughCoinsDialog = false
    
    // MARK: - Computed Properties (from Coordinator)
    
    var questionText: String {
        coordinator.currentQuestion?.promptTargetLanguage ?? ""
    }
    
    var translationText: String {
        coordinator.currentQuestion?.promptNativeLanguage ?? ""
    }
    
    var currentQuestionIndex: Int {
        coordinator.questionCount + 1
    }
    
    var totalQuestions: Int {
        max(coordinator.gameState?.availableAttributes.count ?? 20, coordinator.questionCount + 1)
    }
    
    var progressPercentage: Int {
        Int((Double(currentQuestionIndex) / Double(totalQuestions)) * 100)
    }
    
    var translateCostText: String {
        "\(translateCost)"
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
    
    func onAnswerTapped(_ answer: AnswerState) {
        guard !isProcessing else { return }
        isProcessing = true
        showTranslation = false
        
        // Show thinking animation
        birdState = .thinking
        
        Task {
            // Brief thinking delay for UX
            try? await Task.sleep(nanoseconds: 800_000_000)
            
            let shouldGuess = coordinator.processAnswer(answer: answer)
            
            if shouldGuess {
                // Show pointing state before navigating
                birdState = .pointing
                try? await Task.sleep(nanoseconds: 600_000_000)
                isProcessing = false
                router.push(.mindReaderGuess)
            } else {
                birdState = .normal
                isProcessing = false
            }
        }
    }
    
    func onTranslateTapped() {
        guard !showTranslation else { return }
        
        if statsService.coins < translateCost {
            showNotEnoughCoinsDialog = true
            return
        }
        
        showTranslateConfirmDialog = true
    }
    
    func confirmTranslation() {
        Task {
            try? await statsService.deductCoins(translateCost)
            showTranslation = true
            coordinator.translationRevealed = true
            showTranslateConfirmDialog = false
        }
    }
    
    func onListenTapped() {
        // Text-to-speech logic - future enhancement
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
        
        let viewModel = MindReaderGameViewModel(router: MockRouter(), statsService: statsService, coordinator: coordinator)
        
        coordinator.currentQuestion = QuestionAttribute(id: "1", promptTargetLanguage: "Is it an animal?", promptNativeLanguage: "هل هو حيوان؟")
        coordinator.questionCount = 0
        
        return viewModel
    }
}
