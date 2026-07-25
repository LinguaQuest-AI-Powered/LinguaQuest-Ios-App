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
    
    /// True while the user is physically holding the mic button.
    private(set) var isHoldingMic: Bool = false

    private let scenarioId: String
    private(set) var scenario: BossScenario?
    
    private let scenarioRepository: ScenarioRepositoryProtocol
    private let repository: BossLevelRepositoryProtocol
    private let startSessionUseCase: StartBossLevelSessionUseCaseProtocol
    private let stopSessionUseCase: StopBossLevelSessionUseCaseProtocol
    private let evaluateStageUseCase: EvaluateBossStageUseCaseProtocol
    private let router: RouterProtocol
    
    private var stateListenTask: Task<Void, Never>?
    private var timerTask: Task<Void, Never>?

    init(
        scenarioId: String,
        scenarioRepository: ScenarioRepositoryProtocol,
        repository: BossLevelRepositoryProtocol,
        startSessionUseCase: StartBossLevelSessionUseCaseProtocol,
        stopSessionUseCase: StopBossLevelSessionUseCaseProtocol,
        evaluateStageUseCase: EvaluateBossStageUseCaseProtocol,
        router: RouterProtocol
    ) {
        self.scenarioId = scenarioId
        self.scenarioRepository = scenarioRepository
        self.repository = repository
        self.startSessionUseCase = startSessionUseCase
        self.stopSessionUseCase = stopSessionUseCase
        self.evaluateStageUseCase = evaluateStageUseCase
        self.router = router
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
                viewState = .error("Failed to load scenario: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Session

    func startChallenge() {
        guard let scenario = scenario else { return }
        viewState = .active
        messages.removeAll()
        timeRemaining = 120
        startTimer()
        
        Task {
            let prompt = PromptFactory.createLiveSessionPrompt(scenario: scenario)
            do {
                print("🎯 [ViewModel] startChallenge() — calling startSession…")
                try await startSessionUseCase.execute(systemInstruction: prompt)
            } catch {
                viewState = .error(error.localizedDescription)
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
                viewState = .result(result)
            } catch {
                viewState = .error("Evaluation failed: \(error.localizedDescription)")
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
                feedback_message: L10n.BossLevel.timeoutFeedback
            )
            viewState = .result(result)
        }
    }

    // MARK: - Hold-to-Talk

    func startSpeaking() {
        guard case .active = viewState, !isHoldingMic else { return }
        isHoldingMic = true
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
            self.messages.append(message)
        case .error(let error):
            if case .active = self.viewState {
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
}
