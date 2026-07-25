//
//  LiveRoleplayService.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation

enum LiveRoleplayServiceEvent {
    case connected
    case textPart(String)
    case userTranscript(String)
    case aiTranscriptChunk(String)
    case audioPart(Data)
    case turnCompleted
    case error(Error)
    case disconnected
}

final class LiveRoleplayService: NSObject, URLSessionWebSocketDelegate {

    // MARK: - State

    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?

    /// True only after didOpenWithProtocol fires (TCP+TLS+WS handshake done).
    private var isSocketOpen = false

    /// True after Gemini replies with setupComplete — audio must not be sent before this.
    private var isSetupComplete = false

    /// Audio chunks queued while setup is in-flight.
    private var pendingChunks: [Data] = []

    private var pendingSystemInstruction = ""

    var onEvent: ((LiveRoleplayServiceEvent) -> Void)?

    // MARK: - Public API

    func connect(systemInstruction: String) {
        pendingSystemInstruction = systemInstruction
        isSocketOpen = false
        isSetupComplete = false
        pendingChunks.removeAll()

        let apiKey = AppConfig.aiKey
        guard !apiKey.isEmpty else {
            print("🚀 [LiveRoleplay] ❌ API key is empty")
            onEvent?(.error(NSError(domain: "LiveRoleplayService", code: -3,
                                    userInfo: [NSLocalizedDescriptionKey: "API key missing."])))
            return
        }

        let urlString = "wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            onEvent?(.error(NSError(domain: "LiveRoleplayService", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "Invalid WebSocket URL"])))
            return
        }

        print("🚀 [LiveRoleplay] Opening WebSocket…")
        let config = URLSessionConfiguration.default
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "LiveRoleplayQueue"

        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
        // Actual send happens in didOpenWithProtocol once the handshake finishes.
    }

    func disconnect() {
        print("🚀 [LiveRoleplay] Disconnecting…")
        isSocketOpen = false
        isSetupComplete = false
        pendingChunks.removeAll()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        urlSession?.invalidateAndCancel()
        urlSession = nil
        onEvent?(.disconnected)
    }

    /// Tells Gemini the user has finished their turn.
    /// For native-audio models, we send a small silence buffer via realtimeInput
    /// so the model detects end-of-speech. Sending clientContent.turnComplete
    /// causes a 1007 "Invalid Argument" on native audio preview models.
    func sendClientTurnComplete() {
        guard isSocketOpen, isSetupComplete else { return }
        print("🚀 [LiveRoleplay] Sending end-of-turn silence")
        // Send ~200ms of silence (16kHz × 2 bytes × 0.2s = 6400 bytes of zeros)
        let silenceData = Data(count: 6400)
        transmitAudio(silenceData)
    }

    /// Enqueues a 16kHz / mono / 16-bit PCM chunk.
    /// If setup is not yet complete the chunk is held until setupComplete arrives.
    func sendAudioChunk(_ pcmData: Data) {
        guard isSocketOpen else {
            print("🚀 [LiveRoleplay] ⚠️ sendAudioChunk called but socket not open yet — dropping")
            return
        }
        guard isSetupComplete else {
            pendingChunks.append(pcmData)
            return
        }
        transmitAudio(pcmData)
    }

    // MARK: - URLSessionWebSocketDelegate

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("🚀 [LiveRoleplay] WebSocket connected ✅ — sending setup message")
        isSocketOpen = true
        sendSetupMessage(systemInstruction: pendingSystemInstruction)
        listen()
        onEvent?(.connected)
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        let reasonStr = reason.flatMap { String(data: $0, encoding: .utf8) } ?? "none"
        print("🚀 [LiveRoleplay] WebSocket closed — code:\(closeCode.rawValue) reason:\(reasonStr)")
        if isSocketOpen {
            isSocketOpen = false
            isSetupComplete = false
            onEvent?(.disconnected)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error {
            print("🚀 [LiveRoleplay] Task error: \(error.localizedDescription)")
            if isSocketOpen {
                isSocketOpen = false
                isSetupComplete = false
                onEvent?(.error(error))
            }
        }
    }

    // MARK: - Private send helpers

    private func sendSetupMessage(systemInstruction: String) {
        let emptyConfig = GeminiLiveAudioTranscriptionConfig()
        let payload = GeminiLiveSetupPayload(
            model: "models/gemini-2.5-flash-native-audio-preview-12-2025",
            generationConfig: GeminiLiveGenerationConfig(responseModalities: ["AUDIO"]),
            systemInstruction: GeminiLiveSystemInstruction(parts: [GeminiLivePart(text: systemInstruction)]),
            inputAudioTranscription: emptyConfig,
            outputAudioTranscription: emptyConfig
        )
        print("🚀 [LiveRoleplay] Sending setup — model: gemini-2.5-flash-native-audio-preview-12-2025")
        sendJSON(GeminiLiveSetupMessage(setup: payload))
    }

    private func transmitAudio(_ pcmData: Data) {
        let b64 = pcmData.base64EncodedString()
        let msg = GeminiLiveRealtimeInputMessage(
            realtimeInput: GeminiLiveRealtimeInputPayload(
                mediaChunks: [GeminiLiveMediaChunk(mimeType: "audio/pcm;rate=16000", data: b64)]
            )
        )
        print("🎙️ [LiveRoleplay] Sent PCM chunk: \(pcmData.count) bytes")
        sendJSON(msg)
    }

    private func sendJSON<T: Encodable>(_ object: T) {
        guard isSocketOpen, let task = webSocketTask else { return }
        do {
            let data = try JSONEncoder().encode(object)
            guard let jsonStr = String(data: data, encoding: .utf8) else { return }
            task.send(.string(jsonStr)) { error in
                if let error {
                    print("🚀 [LiveRoleplay] Send error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("🚀 [LiveRoleplay] Encoding error: \(error)")
        }
    }

    // MARK: - Receive loop

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self, self.isSocketOpen else { return }

            switch result {
            case .failure(let error):
                print("🚀 [LiveRoleplay] Receive error: \(error.localizedDescription)")
                self.isSocketOpen = false
                self.isSetupComplete = false
                self.onEvent?(.error(error))

            case .success(let message):
                let text: String?
                switch message {
                case .string(let s):  text = s
                case .data(let d):    text = String(data: d, encoding: .utf8)
                @unknown default:     text = nil
                }
                if let text { self.parseIncomingMessage(text) }
                self.listen()
            }
        }
    }

    private func parseIncomingMessage(_ jsonText: String) {
        guard let data = jsonText.data(using: .utf8) else { return }

        // Debug: log the top-level JSON keys so we can see what the server sends
        if let rawObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            let keys = rawObj.keys.sorted().joined(separator: ", ")
            print("🚀 [LiveRoleplay] Incoming keys: [\(keys)]")
        }

        do {
            let msg = try JSONDecoder().decode(GeminiLiveServerMessage.self, from: data)

            // setupComplete arrives as {} — just its presence means we're ready
            if msg.setupComplete != nil {
                print("🚀 [LiveRoleplay] Setup complete ✅ — flushing \(pendingChunks.count) queued chunks")
                isSetupComplete = true
                let queued = pendingChunks
                pendingChunks.removeAll()
                for chunk in queued { transmitAudio(chunk) }
            }

            let inputTxt = msg.serverContent?.inputTranscription?.text ?? msg.inputTranscription?.text ?? msg.inputAudioTranscription?.text
            if let inputTxt = inputTxt, !inputTxt.isEmpty {
                print("🚀 [LiveRoleplay] User Transcript: \(inputTxt)")
                onEvent?(.userTranscript(inputTxt))
            }

            let outputTxt = msg.serverContent?.outputTranscription?.text ?? msg.outputTranscription?.text ?? msg.outputAudioTranscription?.text
            if let outputTxt = outputTxt, !outputTxt.isEmpty {
                print("🚀 [LiveRoleplay] AI Transcript Chunk: \(outputTxt)")
                onEvent?(.aiTranscriptChunk(outputTxt))
            }

            guard let content = msg.serverContent else { return }

            if let parts = content.modelTurn?.parts {
                for part in parts {
                    if let text = part.text, !text.isEmpty {
                        print("🚀 [LiveRoleplay] ModelTurn Text: \(text.prefix(80))")
                        onEvent?(.textPart(text))
                    }
                    if let inline = part.inlineData,
                       let b64 = inline.data,
                       let audioData = Data(base64Encoded: b64) {
                        print("🚀 [LiveRoleplay] Audio chunk from Gemini: \(audioData.count) bytes")
                        onEvent?(.audioPart(audioData))
                    }
                }
            }

            if content.turnComplete == true {
                print("🚀 [LiveRoleplay] Turn complete")
                onEvent?(.turnCompleted)
            }
            if content.interrupted == true {
                print("🚀 [LiveRoleplay] Interrupted")
                onEvent?(.turnCompleted)
            }

        } catch {
            print("🚀 [LiveRoleplay] Decode error: \(error)\nRaw: \(jsonText.prefix(300))")
        }
    }
}
