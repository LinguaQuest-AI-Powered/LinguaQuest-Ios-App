//
//  MindReaderGameCoordinator.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation
import Observation

/// Shared game state holder that bridges AI use cases with the presentation layer.
/// Registered as `.container` scope in DI so all MindReader ViewModels share the same instance.
@MainActor
@Observable
final class MindReaderGameCoordinator {
    private let getCategoriesUseCase: GetCategoriesUseCase
    private let requestNextGameStepUseCase: RequestNextGameStepUseCase
    private let requestQuizChoicesUseCase: RequestQuizChoicesUseCase
    private let verifyHonestyUseCase: VerifyHonestyUseCase
    
    // MARK: - Shared State
    
    var availableCategories: [GameCategory] = []
    var selectedCategory: GameCategory?
    var history: [GameTurn] = []
    var questionCount: Int = 0
    
    var currentQuestionTarget: String?
    var currentQuestionNative: String?
    var bestGuess: (word: String, translation: String, emoji: String)?
    var quizChoices: [QuizChoice] = []
    
    var coinsEarned: Int = 0
    var xpEarned: Int = 0
    var failureReason: String?
    
    var isLoading: Bool = false
    var errorMessage: String?
    var showAiUnavailableDialog: Bool = false
    var translationRevealed: Bool = false
    
    init(
        getCategoriesUseCase: GetCategoriesUseCase,
        requestNextGameStepUseCase: RequestNextGameStepUseCase,
        requestQuizChoicesUseCase: RequestQuizChoicesUseCase,
        verifyHonestyUseCase: VerifyHonestyUseCase
    ) {
        self.getCategoriesUseCase = getCategoriesUseCase
        self.requestNextGameStepUseCase = requestNextGameStepUseCase
        self.requestQuizChoicesUseCase = requestQuizChoicesUseCase
        self.verifyHonestyUseCase = verifyHonestyUseCase
    }
    
    // MARK: - Public API
    
    func loadCategories() {
        availableCategories = getCategoriesUseCase.execute()
    }
    
    func initializeGame(category: GameCategory) async {
        selectedCategory = category
        history = []
        questionCount = 0
        translationRevealed = false
        
        await requestNextStep()
    }
    
    func requestNextStep() async {
        guard let category = selectedCategory else { return }
        isLoading = true
        errorMessage = nil
        translationRevealed = false
        
        do {
            let decision = try await requestNextGameStepUseCase.execute(category: category, history: history)
            
            switch decision {
            case .question(let target, let native):
                self.currentQuestionTarget = target
                self.currentQuestionNative = native
                self.bestGuess = nil
            case .guess(let word, let translation, let emoji):
                self.bestGuess = (word: word, translation: translation, emoji: emoji)
                self.currentQuestionTarget = nil
                self.currentQuestionNative = nil
            }
            
            isLoading = false
        } catch {
            showAiUnavailableDialog = true
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func processAnswer(answer: AnswerState) async -> Bool {
        guard let category = selectedCategory, let target = currentQuestionTarget, let native = currentQuestionNative else { return false }
        
        let turn = GameTurn(
            index: history.count + 1,
            questionTargetText: target,
            questionNativeText: native,
            answer: answer
        )
        history.append(turn)
        questionCount += 1
        
        isLoading = true
        errorMessage = nil
        translationRevealed = false
        
        do {
            let decision = try await requestNextGameStepUseCase.execute(category: category, history: history)
            isLoading = false
            
            switch decision {
            case .question(let t, let n):
                currentQuestionTarget = t
                currentQuestionNative = n
                return false
            case .guess(let word, let translation, let emoji):
                bestGuess = (word: word, translation: translation, emoji: emoji)
                return true
            }
        } catch {
            showAiUnavailableDialog = true
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func requestQuiz() async {
        guard let category = selectedCategory, let guess = bestGuess else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            quizChoices = try await requestQuizChoicesUseCase.execute(category: category, correctWordTargetLanguage: guess.word, correctWordNativeLanguage: guess.translation)
            isLoading = false
        } catch {
            showAiUnavailableDialog = true
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func validateQuiz(choice: QuizChoice) -> Bool {
        if choice.isCorrect {
            coinsEarned = 20
            xpEarned = 50
            return true
        } else {
            failureReason = L10n.MindReader.bustedQuizFailed
            return false
        }
    }
    
    func validateGiveUp(claimedWord: String) async -> Bool {
        guard let category = selectedCategory else { return false }
        isLoading = true
        errorMessage = nil
        
        do {
            let verdict = try await verifyHonestyUseCase.execute(category: category, history: history, claimedWord: claimedWord)
            isLoading = false
            
            if verdict.isHonest {
                coinsEarned = 10
                xpEarned = 25
                return true
            } else {
                failureReason = verdict.explanation
                return false
            }
        } catch {
            showAiUnavailableDialog = true
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func reset() {
        selectedCategory = nil
        history = []
        questionCount = 0
        currentQuestionTarget = nil
        currentQuestionNative = nil
        bestGuess = nil
        quizChoices = []
        coinsEarned = 0
        xpEarned = 0
        failureReason = nil
        isLoading = false
        errorMessage = nil
        translationRevealed = false
    }
}
