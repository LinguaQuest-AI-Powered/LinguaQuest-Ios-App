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
    var recordingState: VoiceRecordingState = .idle
    var targetSentence: String = L10n.SpeakingLab.mockTargetSentence
    
    var recordingDuration: Int = 0
    var showReviewDialog: Bool = false
    private var timer: Timer?
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func toggleRecording() {
        if recordingState == .idle {
            startRecording()
        } else if recordingState == .recording {
            stopRecording()
        }
    }
    
    private func startRecording() {
        recordingState = .recording
        recordingDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.recordingDuration += 1
            }
        }
        // TODO: Implement actual audio recording logic
    }
    
    private func stopRecording() {
        recordingState = .finished
        timer?.invalidate()
        timer = nil
        showReviewDialog = true
        // TODO: Implement stop recording logic and processing
    }
    
    func discardRecording() {
        showReviewDialog = false
        recordingState = .idle
        recordingDuration = 0
    }
    
    func processRecording() {
        showReviewDialog = false
        router.push(.voiceGameResult)
    }
    
    func skip() {
        // Handle skip
    }
    
    func goBack() {
        router.pop()
    }
}
