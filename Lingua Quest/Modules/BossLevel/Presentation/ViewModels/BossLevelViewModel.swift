//
//  BossLevelViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI
import Observation

enum BossLevelViewState {
    case loading
    case lobby(BossScenario)
    case active
    case evaluating
    case result(BossEvaluationResult)
    case error(String)
}

@MainActor
@Observable
final class BossLevelViewModel {
    private(set) var viewState: BossLevelViewState = .loading
    private(set) var sessionState = BossLevelSessionState()
    private(set) var messages: [RoleplayMessage] = []
    private(set) var timeRemaining: Int = 120
    
    var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var coins: Int {
        statsService.coins
    }
    
    /// True while the user is physically holding the mic button.
    private(set) var isHoldingMic: Bool = false
    
    private var isAITurnActive: Bool = false
    private var canAppendToUserBubble: Bool = false
    var showAiUnavailableDialog: Bool = false

    private let scenarioId: String
    private(set) var scenario: BossScenario?
    
    private let scenarioRepository: ScenarioRepositoryProtocol
    private let repository: BossLevelRepositoryProtocol
    private let startSessionUseCase: StartBossLevelSessionUseCaseProtocol
    private let stopSessionUseCase: StopBossLevelSessionUseCaseProtocol
    private let evaluateStageUseCase: EvaluateBossStageUseCaseProtocol
    private let router: RouterProtocol
    private let statsService: StatsServiceProtocol
    private let soundPlayer: AppSoundPlayer
    
    private var stateListenTask: Task<Void, Never>?
    private var timerTask: Task<Void, Never>?

    init(
        scenarioId: String,
        scenarioRepository: ScenarioRepositoryProtocol,
        repository: BossLevelRepositoryProtocol,
        startSessionUseCase: StartBossLevelSessionUseCaseProtocol,
        stopSessionUseCase: StopBossLevelSessionUseCaseProtocol,
        evaluateStageUseCase: EvaluateBossStageUseCaseProtocol,
        router: RouterProtocol,
        statsService: StatsServiceProtocol,
        soundPlayer: AppSoundPlayer
    ) {
        self.scenarioId = scenarioId
        self.scenarioRepository = scenarioRepository
        self.repository = repository
        self.startSessionUseCase = startSessionUseCase
        self.stopSessionUseCase = stopSessionUseCase
        self.evaluateStageUseCase = evaluateStageUseCase
        self.router = router
        self.statsService = statsService
        self.soundPlayer = soundPlayer
    }

    // MARK: - Lifecycle

    func onAppear() {
        startListeningToRepository()
        loadScenario()
    }

    func onDisappear() {
        stateListenTask?.cancel()
        stateListenTask = nil
        timerTask?.cancel()
        timerTask = nil
        Task { await stopSessionUseCase.execute() }
    }
    
    private func loadScenario() {
        Task {
            do {
                viewState = .loading
                scenario = try await scenarioRepository.getScenario(id: scenarioId)
                if let scenario = scenario {
                    viewState = .lobby(scenario)
                }
            } catch {
                if error.isAIUnavailableError {
                    showAiUnavailableDialog = true
                    viewState = .loading
                } else {
                    viewState = .error(error.userFriendlyMessage)
                }
            }
        }
    }

    // MARK: - Session

    func startChallenge() {
        guard let scenario = scenario else { return }
        viewState = .active
        messages.removeAll()
        isAITurnActive = false
        canAppendToUserBubble = false
        timeRemaining = 120
        startTimer()
        
        Task {
            let prompt = PromptFactory.createLiveSessionPrompt(scenario: scenario)
            do {
                print("🎯 [ViewModel] startChallenge() — calling startSession…")
                try await startSessionUseCase.execute(systemInstruction: prompt)
            } catch {
                if error.isAIUnavailableError {
                    showAiUnavailableDialog = true
                    viewState = .lobby(scenario)
                } else {
                    viewState = .error(error.userFriendlyMessage)
                }
            }
        }
    }

    func endChallenge() {
        guard let scenario = scenario else { return }
        isHoldingMic = false
        timerTask?.cancel()
        timerTask = nil
        viewState = .evaluating
        
        Task {
            await stopSessionUseCase.execute()
            do {
                let transcript = messages.map { "\($0.sender): \($0.text)" }.joined(separator: "\n")
                let result = try await evaluateStageUseCase.execute(scenario: scenario, transcript: transcript)
                soundPlayer.play(sound: result.task_completed ? .success : .fail)
                viewState = .result(result)
            } catch {
                soundPlayer.play(sound: .fail)
                if error.isAIUnavailableError {
                    showAiUnavailableDialog = true
                    viewState = .active
                } else {
                    viewState = .error(error.userFriendlyMessage)
                }
            }
        }
    }

    func onCloseTapped() {
        timerTask?.cancel()
        timerTask = nil
        Task {
            await stopSessionUseCase.execute()
            router.pop()
        }
    }

    // MARK: - Rewards
    
    private var hasAwarded = false
    
    func claimReward() {
        guard !hasAwarded else { return }
        guard case .result(let result) = viewState else { return }
        guard result.task_completed, let reward = result.reward else { return }
        
        hasAwarded = true
        Task {
            try? await statsService.adjustWallet(coinsDelta: reward.coins, xpDelta: reward.xp)
        }
    }

    // MARK: - Timer

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while let self = self, self.timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.handleTimeout()
                    break
                }
            }
        }
    }

    private func handleTimeout() {
        isHoldingMic = false
        timerTask?.cancel()
        timerTask = nil
        Task {
            await stopSessionUseCase.execute()
            let result = BossEvaluationResult(
                task_completed: false,
                fluency_score: 0,
                grammar_score: 0,
                vocabulary_score: 0,
                feedback_message: L10n.BossLevel.timeoutFeedback,
                what_went_well: [],
                areas_to_improve: []
            )
            soundPlayer.play(sound: .fail)
            viewState = .result(result)
        }
    }

    // MARK: - Hold-to-Talk

    func startSpeaking() {
        guard case .active = viewState, !isHoldingMic else { return }
        isHoldingMic = true
        isAITurnActive = false
        canAppendToUserBubble = false
        repository.startSpeaking()
    }

    func stopSpeaking() {
        guard isHoldingMic else { return }
        isHoldingMic = false
        repository.stopSpeaking()
    }

    // MARK: - Event Handling

    private func startListeningToRepository() {
        stateListenTask = Task { [weak self] in
            guard let self else { return }
            for await event in self.repository.stateStream {
                self.handleEvent(event)
            }
        }
    }

    private func handleEvent(_ event: BossLevelEvent) {
        switch event {
        case .stateChanged(let newState):
            self.sessionState = newState
        case .messageReceived(let message):
            self.isAITurnActive = false
            if self.canAppendToUserBubble, let lastIndex = self.messages.indices.last, self.messages[lastIndex].sender == .user {
                let existing = self.messages[lastIndex].text
                if existing.hasSuffix(" ") || message.text.hasPrefix(" ") {
                    self.messages[lastIndex].text += message.text
                } else {
                    self.messages[lastIndex].text += " " + message.text
                }
            } else {
                self.canAppendToUserBubble = true
                self.messages.append(message)
            }
        case .aiTranscriptChunk(let chunk):
            self.canAppendToUserBubble = false
            if self.isAITurnActive, let lastIndex = self.messages.indices.last, self.messages[lastIndex].sender == .ai {
                self.messages[lastIndex].text += chunk
            } else {
                self.isAITurnActive = true
                self.messages.append(RoleplayMessage(sender: .ai, text: chunk))
            }
        case .turnCompleted:
            self.isAITurnActive = false
            self.canAppendToUserBubble = false
        case .error(let error):
            if case .active = self.viewState {
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
}
