//
//  BossLevelViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class BossLevelViewModel {
    private(set) var state = BossLevelSessionState()
    private(set) var messages: [RoleplayMessage] = []
    private(set) var isSessionStarted: Bool = false
    private(set) var errorMessage: String? = nil
    /// True while the user is physically holding the mic button.
    private(set) var isHoldingMic: Bool = false

    let scenarioTitle: String

    var descriptionText: String {
        "Hold the mic button to speak with Lingo. Release to send and wait for a reply."
    }

    private let repository: BossLevelRepositoryProtocol
    private let startSessionUseCase: StartBossLevelSessionUseCaseProtocol
    private let stopSessionUseCase: StopBossLevelSessionUseCaseProtocol
    private let router: RouterProtocol
    private var stateListenTask: Task<Void, Never>?

    init(
        scenarioTitle: String = "Boss Level",
        repository: BossLevelRepositoryProtocol,
        startSessionUseCase: StartBossLevelSessionUseCaseProtocol,
        stopSessionUseCase: StopBossLevelSessionUseCaseProtocol,
        router: RouterProtocol
    ) {
        self.scenarioTitle = scenarioTitle
        self.repository = repository
        self.startSessionUseCase = startSessionUseCase
        self.stopSessionUseCase = stopSessionUseCase
        self.router = router
    }

    // MARK: - Lifecycle

    func onAppear() {
        startListeningToRepository()
    }

    func onDisappear() {
        stateListenTask?.cancel()
        stateListenTask = nil
        Task { await stopSessionUseCase.execute() }
    }

    // MARK: - Session

    func startChallenge() {
        isSessionStarted = true
        errorMessage = nil
        Task {
            let prompt = """
            You are Lingo, a friendly AI language guide in LinguaQuest.
            The user will press and hold a button while speaking to you.
            Keep your replies concise (1–3 sentences), warm, and natural — like a real conversation.
            Never use markdown or emoji.
            """
            do {
                print("🎯 [ViewModel] startChallenge() — calling startSession…")
                try await startSessionUseCase.execute(systemInstruction: prompt)
                print("🎯 [ViewModel] startSession() returned successfully")
            } catch {
                print("🎯 [ViewModel] startSession() FAILED: \(error.localizedDescription)")
                isSessionStarted = false
                errorMessage = error.localizedDescription
            }
        }
    }

    func endChallenge() {
        isHoldingMic = false
        isSessionStarted = false
        Task { await stopSessionUseCase.execute() }
    }

    func onCloseTapped() {
        Task {
            await stopSessionUseCase.execute()
            router.pop()
        }
    }

    // MARK: - Hold-to-Talk

    /// Called when the user presses down the mic button.
    func startSpeaking() {
        guard isSessionStarted, !isHoldingMic else { return }
        isHoldingMic = true
        repository.startSpeaking()
        print("🎯 [ViewModel] startSpeaking()")
    }

    /// Called when the user releases the mic button.
    func stopSpeaking() {
        guard isHoldingMic else { return }
        isHoldingMic = false
        repository.stopSpeaking()
        print("🎯 [ViewModel] stopSpeaking()")
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
            self.state = newState
        case .messageReceived(let message):
            print("🎯 [ViewModel] Message from \(message.sender): \(message.text.prefix(80))")
            self.messages.append(message)
        case .error(let error):
            print("🎯 [ViewModel] ERROR: \(error.localizedDescription)")
        }
    }
}
