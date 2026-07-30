//
//  VoiceGameViewModel.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation
import Observation

enum VoiceRecordingState {
    case idle
    case recording
    case finished
}

@MainActor
@Observable
class VoiceGameViewModel {
    let router: RouterProtocol
    private let getSentencesUseCase: GetDailyVoiceSentencesUseCase
    private let evaluateUseCase: EvaluateVoiceUseCase
    private let audioService: AudioRecorderServiceProtocol
    private let speechService: SpeechSynthesizerProtocol
    private let statsService: StatsServiceProtocol
    
    var coins: Int {
        statsService.coins
    }
    
    var recordingState: VoiceRecordingState = .idle
    var targetSentence: String = ""
    
    var recordingDuration: Int = 0
    var showReviewDialog: Bool = false
    var isLoadingResult: Bool = false
    var isLoadingSentences: Bool = false
    var isPlayingAudio: Bool = false
    var loadError: String?
    private var timer: Timer?
    private var advanceToken: NotificationToken?
    
    var dailySentences: [VoiceSentence] = []
    var currentSentenceIndex: Int = 0
    var audioData: Data?
    var recordingFileURL: URL?
    
    init(router: RouterProtocol,
         statsService: StatsServiceProtocol,
         getSentencesUseCase: GetDailyVoiceSentencesUseCase,
         evaluateUseCase: EvaluateVoiceUseCase,
         audioService: AudioRecorderServiceProtocol,
         speechService: SpeechSynthesizerProtocol) {
        self.router = router
        self.statsService = statsService
        self.getSentencesUseCase = getSentencesUseCase
        self.evaluateUseCase = evaluateUseCase
        self.audioService = audioService
        self.speechService = speechService
        
        Task {
            await loadSentences()
        }
        
        let token = NotificationCenter.default.addObserver(
            forName: .voiceGameDidAdvanceLevel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.advanceToNextSentence()
        }
        advanceToken = NotificationToken(token: token)
    }
    
    func playTargetSentence() {
        // Determine language code for speech synthesis from the sentence
        let languageCode = currentSentence?.language ?? "en"
        let speechCode = AppLanguage.speechCode(for: languageCode)
        
        isPlayingAudio = true
        speechService.onFinishSpeaking = { [weak self] in
            Task { @MainActor in
                self?.isPlayingAudio = false
            }
        }
        speechService.speak(text: targetSentence, languageCode: speechCode)
    }
    
    var currentSentence: VoiceSentence? {
        guard currentSentenceIndex < dailySentences.count else { return nil }
        return dailySentences[currentSentenceIndex]
    }
    
    private func loadSentences() async {
        isLoadingSentences = true
        loadError = nil
        do {
            self.dailySentences = try await getSentencesUseCase.execute()
            if let first = dailySentences.first {
                self.targetSentence = first.text
            }
        } catch {
            print("Failed to load daily sentences: \(error)")
            loadError = error.localizedDescription
        }
        isLoadingSentences = false
    }
    
    func retrySentences() {
        Task {
            await loadSentences()
        }
    }
    
    func toggleRecording() {
        if recordingState == .idle {
            startRecording()
        } else if recordingState == .recording {
            stopRecording()
        }
    }
    
    private func startRecording() {
        Task {
            let granted = await audioService.requestPermissions()
            guard granted else { return }
            
            do {
                try audioService.startRecording()
                recordingState = .recording
                recordingDuration = 0
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    Task { @MainActor in
                        self?.recordingDuration += 1
                    }
                }
            } catch {
                print("Failed to start recording: \(error)")
            }
        }
    }
    
    private func stopRecording() {
        recordingState = .finished
        timer?.invalidate()
        timer = nil
        self.audioData = audioService.stopRecording()
        self.recordingFileURL = audioService.getRecordingURL()
        showReviewDialog = true
    }
    
    func discardRecording() {
        showReviewDialog = false
        recordingState = .idle
        recordingDuration = 0
        audioData = nil
        recordingFileURL = nil
    }
    
    func processRecording() {
        guard let data = audioData else { return }
        showReviewDialog = false
        
        router.push(.voiceGameResult(audioData: data, sentence: dailySentences[currentSentenceIndex]))
    }
    
    /// Called when returning from result screen after retry
    func resetForRetry() {
        recordingState = .idle
        recordingDuration = 0
        audioData = nil
        recordingFileURL = nil
        showReviewDialog = false
    }
    
    private func advanceToNextSentence() {
        if currentSentenceIndex < dailySentences.count - 1 {
            currentSentenceIndex += 1
            targetSentence = dailySentences[currentSentenceIndex].text
            resetForRetry()
        } else {
            router.popToRoot()
        }
    }
    
    func skip() {
        advanceToNextSentence()
    }
    
    func goBack() {
        router.pop()
    }
}
