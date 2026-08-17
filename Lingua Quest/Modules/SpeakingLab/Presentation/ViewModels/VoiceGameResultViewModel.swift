//
//  VoiceGameResultViewModel.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import SwiftUI
import Observation

enum VoiceGameResultState {
    case evaluating
    case success
    case failure
}

@MainActor
@Observable
final class VoiceGameResultViewModel {
    var state: VoiceGameResultState = .evaluating
    var rating: Int = 0
    var words: [WordResult] = []
    var xpPoints: Int = 0
    var coinsEarned: Int = 0
    var advice: String = ""
    var showAiUnavailableDialog = false
    
    var coins: Int {
        statsService.coins
    }
    
    private let router: RouterProtocol
    private let evaluateUseCase: EvaluateVoiceUseCase
    private let saveProgressUseCase: SaveVoiceProgressUseCase
    private let statsService: StatsServiceProtocol
    private let soundPlayer: AppSoundPlayer
    private let audioData: Data
    private let sentence: VoiceSentence
    
    init(router: RouterProtocol, evaluateUseCase: EvaluateVoiceUseCase, saveProgressUseCase: SaveVoiceProgressUseCase, statsService: StatsServiceProtocol, soundPlayer: AppSoundPlayer, audioData: Data, sentence: VoiceSentence) {
        self.router = router
        self.evaluateUseCase = evaluateUseCase
        self.saveProgressUseCase = saveProgressUseCase
        self.statsService = statsService
        self.soundPlayer = soundPlayer
        self.audioData = audioData
        self.sentence = sentence
        
        startEvaluation()
    }
    
    private func startEvaluation() {
        state = .evaluating
        
        Task {
            do {
                let result = try await evaluateUseCase.execute(audioData: audioData, targetText: sentence.text)
                await MainActor.run {
                    processResult(result)
                }
            } catch {
                print("Evaluation failed: \(error)")
                await MainActor.run {
                    state = .failure
                    if error.isAIUnavailableError {
                        showAiUnavailableDialog = true
                    }
                    soundPlayer.play(sound: .fail)
                }
            }
        }
    }
    
    private func processResult(_ result: VoiceEvaluationResult) {
        self.rating = result.rating
        
        // Build WordResult list matching the original text vs correctness
        let sentenceWords = sentence.text.split(separator: " ").map { String($0) }
        var mappedWords: [WordResult] = []
        
        for word in sentenceWords {
            let cleanWord = word.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
            let isWrong = result.wrongWords.contains { $0.lowercased() == cleanWord }
            mappedWords.append(WordResult(word: word, isCorrect: !isWrong))
        }
        
        self.words = mappedWords
        self.xpPoints = result.rating * 10
        self.coinsEarned = result.rating >= 7 ? 10 : 2
        self.state = result.rating >= 6 ? .success : .failure
        self.advice = result.advice
        
        soundPlayer.play(sound: self.state == .success ? .success : .fail)
        
        if result.rating >= 6 {
            Task {
                do {
                    try await saveProgressUseCase.execute(sentenceId: sentence.id)
                    try await statsService.adjustWallet(coinsDelta: coinsEarned, xpDelta: xpPoints)
                    await MainActor.run {
                        NotificationCenter.default.post(name: .progressDidUpdate, object: nil)
                    }
                } catch {
                    print("Failed to save voice progress or adjust wallet: \(error)")
                }
            }
        }
    }
    
    func skip() {
        NotificationCenter.default.post(name: .voiceGameDidAdvanceLevel, object: nil)
        router.pop()
    }
    
    /// Retry: pop back to VoiceGameView so user can re-record same sentence
    func playAgain() {
        router.pop()
    }
    
    func onReturnHome() {
        router.popToRoot()
    }
}
