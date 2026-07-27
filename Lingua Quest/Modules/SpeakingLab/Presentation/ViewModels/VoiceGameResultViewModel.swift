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
    
    private let router: RouterProtocol
    private let evaluateUseCase: EvaluateVoiceUseCase
    private let saveProgressUseCase: SaveVoiceProgressUseCase
    private let audioData: Data
    private let sentence: VoiceSentence
    
    init(router: RouterProtocol, evaluateUseCase: EvaluateVoiceUseCase, saveProgressUseCase: SaveVoiceProgressUseCase, audioData: Data, sentence: VoiceSentence) {
        self.router = router
        self.evaluateUseCase = evaluateUseCase
        self.saveProgressUseCase = saveProgressUseCase
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
        
        // Save progress only on success
        if result.rating >= 6 {
            Task {
                do {
                    try await saveProgressUseCase.execute(sentenceId: sentence.id)
                } catch {
                    print("Failed to save voice progress: \(error)")
                }
            }
        }
    }
    
    func skip() {
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
