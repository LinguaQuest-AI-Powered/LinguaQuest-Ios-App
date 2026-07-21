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
    
    var recordingState: VoiceRecordingState = .idle
    var targetSentence: String = L10n.SpeakingLab.mockTargetSentence
    
    var recordingDuration: Int = 0
    var showReviewDialog: Bool = false
    var isLoadingResult: Bool = false
    private var timer: Timer?
    
    var dailySentences: [VoiceSentence] = []
    var currentSentenceIndex: Int = 0
    var audioData: Data?
    
    init(router: RouterProtocol,
         getSentencesUseCase: GetDailyVoiceSentencesUseCase,
         evaluateUseCase: EvaluateVoiceUseCase,
         audioService: AudioRecorderServiceProtocol,
         speechService: SpeechSynthesizerProtocol) {
        self.router = router
        self.getSentencesUseCase = getSentencesUseCase
        self.evaluateUseCase = evaluateUseCase
        self.audioService = audioService
        self.speechService = speechService
        
        Task {
            await loadSentences()
        }
    }
    
    func playTargetSentence() {
        speechService.speak(text: targetSentence, languageCode: "en-US")
    }
    
    private func loadSentences() async {
        do {
            self.dailySentences = try await getSentencesUseCase.execute()
            if let first = dailySentences.first {
                self.targetSentence = first.text
            }
        } catch {
            print("Failed to load daily sentences: \(error)")
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
        showReviewDialog = true
    }
    
    func discardRecording() {
        showReviewDialog = false
        recordingState = .idle
        recordingDuration = 0
        audioData = nil
    }
    
    func processRecording() {
        guard let data = audioData else { return }
        showReviewDialog = false
        
        router.push(.voiceGameResult(audioData: data, sentence: dailySentences[currentSentenceIndex]))
    }
    
    func skip() {
        // Advance to next sentence
    }
    
    func goBack() {
        router.pop()
    }
}
