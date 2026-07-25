//
//  BossLevelRepositoryImpl.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation
import AVFoundation

final class BossLevelRepositoryImpl: BossLevelRepositoryProtocol {

    private let liveService: LiveRoleplayService
    private let audioRecorder: AudioRecorder
    private let audioPlayer: AudioPlayer

    private var state = BossLevelSessionState()
    private var recordingTask: Task<Void, Never>?
    private var stateContinuation: AsyncStream<BossLevelEvent>.Continuation?
    /// Hold-to-Talk flag: only forward PCM chunks while true.
    private var isSpeaking = false

    var stateStream: AsyncStream<BossLevelEvent> {
        AsyncStream { [weak self] continuation in
            self?.stateContinuation = continuation
        }
    }

    init(
        liveService: LiveRoleplayService = LiveRoleplayService(),
        audioRecorder: AudioRecorder = AudioRecorder(),
        audioPlayer: AudioPlayer = AudioPlayer()
    ) {
        self.liveService = liveService
        self.audioRecorder = audioRecorder
        self.audioPlayer = audioPlayer
        setupCallbacks()
    }

    // MARK: - Callbacks

    private func setupCallbacks() {
        liveService.onEvent = { [weak self] event in
            guard let self else { return }
            // Service callbacks come on its serial queue — hop to MainActor for state updates.
            Task { @MainActor in self.handleServiceEvent(event) }
        }

        // Level callbacks come from the AVAudioEngine tap thread (~100 Hz).
        // Only update speaking flag when it actually changes to avoid state-stream spam.
        audioRecorder.onAudioLevelChanged = { [weak self] level in
            guard let self else { return }
            self.state.userAudioLevel = level
            self.state.isUserSpeaking = self.isSpeaking
            self.notifyStateChanged()
        }

        audioPlayer.onAudioLevelChanged = { [weak self] level in
            guard let self else { return }
            self.state.aiAudioLevel = level
            self.state.isAISpeaking = level > 0.05
            self.notifyStateChanged()
        }

        audioPlayer.onPlaybackFinished = { [weak self] in
            guard let self else { return }
            self.state.aiAudioLevel = 0
            self.state.isAISpeaking = false
            self.notifyStateChanged()
        }
    }

    // MARK: - BossLevelRepositoryProtocol

    func startSession(systemInstruction: String) async throws {
        state.status = .connecting
        notifyStateChanged()

        // 1. Microphone permission
        let granted: Bool
        if #available(iOS 17.0, *) {
            granted = await AVAudioApplication.requestRecordPermission()
        } else {
            granted = await withCheckedContinuation { cont in
                AVAudioSession.sharedInstance().requestRecordPermission { cont.resume(returning: $0) }
            }
        }
        guard granted else {
            state.status = .disconnected
            notifyStateChanged()
            throw NSError(domain: "BossLevel", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied. Please enable it in Settings."])
        }

        // 2. Activate shared AVAudioSession ONCE — both recorder and player use it.
        do {
            let s = AVAudioSession.sharedInstance()
            try s.setCategory(.playAndRecord, mode: .voiceChat,
                              options: [.defaultToSpeaker, .allowBluetoothHFP])
            try s.setActive(true, options: .notifyOthersOnDeactivation)
            print("🎙 [Repo] AVAudioSession active ✅")
        } catch {
            state.status = .disconnected
            notifyStateChanged()
            throw error
        }

        // 3. Open WebSocket (setup message sent in didOpenWithProtocol).
        liveService.connect(systemInstruction: systemInstruction)

        // 4. Start microphone and stream every 16kHz PCM chunk to the live service.
        //    Chunks are only forwarded while isSpeaking == true (Hold-to-Talk).
        //    The service also holds chunks in pendingChunks until setupComplete is received.
        recordingTask = Task { [weak self] in
            guard let self else { return }
            print("🎙 [Repo] Recording task started — waiting for Hold-to-Talk")
            let stream = self.audioRecorder.startRecording()
            var chunkCount = 0
            for await pcmChunk in stream {
                guard !Task.isCancelled else { break }
                guard self.isSpeaking else { continue }
                self.liveService.sendAudioChunk(pcmChunk)
                chunkCount += 1
                if chunkCount <= 5 || chunkCount % 100 == 0 {
                    print("🎙 [Repo] Forwarded chunk #\(chunkCount) — \(pcmChunk.count) bytes")
                }
            }
            print("🎙 [Repo] Recording task ended")
        }
    }

    func stopSession() async {
        isSpeaking = false
        recordingTask?.cancel()
        recordingTask = nil

        audioRecorder.stopRecording()
        audioPlayer.stop()
        liveService.disconnect()

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

        state.status = .disconnected
        state.isUserSpeaking = false
        state.isAISpeaking = false
        notifyStateChanged()
        print("🎙 [Repo] Session stopped")
    }

    func startSpeaking() {
        guard !isSpeaking else { return }
        isSpeaking = true
        state.isUserSpeaking = true
        print("🎙 [Repo] startSpeaking — mic open")
        notifyStateChanged()
    }

    func stopSpeaking() {
        guard isSpeaking else { return }
        isSpeaking = false
        state.isUserSpeaking = false
        print("🎙 [Repo] stopSpeaking — sending silence tail for VAD")
        
        // Send ~1s of silence (16kHz × 2 bytes × 1.0s = 32000 bytes of zeros)
        // so the native audio model's VAD detects end-of-speech and responds.
        let silenceDuration: Double = 1.0
        let silenceBytes = Int(16_000 * 2 * silenceDuration)
        let silenceData = Data(count: silenceBytes)
        // Send in smaller chunks to mimic natural audio flow
        let chunkSize = 3200
        for offset in stride(from: 0, to: silenceBytes, by: chunkSize) {
            let end = min(offset + chunkSize, silenceBytes)
            liveService.sendAudioChunk(silenceData[offset..<end])
        }
        
        notifyStateChanged()
    }

    // MARK: - Service Event Handling

    private func handleServiceEvent(_ event: LiveRoleplayServiceEvent) {
        switch event {
        case .connected:
            state.status = .connected
            notifyStateChanged()

        case .textPart(let text):
            stateContinuation?.yield(.messageReceived(RoleplayMessage(sender: .ai, text: text)))

        case .audioPart(let data):
            audioPlayer.playChunk(data)

        case .turnCompleted:
            state.isAISpeaking = false
            notifyStateChanged()

        case .error(let error):
            print("🚀 [Repo] LiveService error: \(error.localizedDescription)")
            state.status = .disconnected
            notifyStateChanged()
            stateContinuation?.yield(.error(error))

        case .disconnected:
            state.status = .disconnected
            state.isUserSpeaking = false
            state.isAISpeaking = false
            notifyStateChanged()
        }
    }

    // MARK: - Helpers

    private func notifyStateChanged() {
        stateContinuation?.yield(.stateChanged(state))
    }
}
