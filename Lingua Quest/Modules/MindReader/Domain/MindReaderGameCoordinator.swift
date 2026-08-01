//
//  MindReaderGameCoordinator.swift
//  Lingua Quest
//
//  Created by siam on 01/08/2026.
//

import Foundation
import Observation

/// Shared game state holder that bridges domain use cases with the presentation layer.
/// Registered as `.container` scope in DI so all MindReader ViewModels share the same instance.
@MainActor
@Observable
final class MindReaderGameCoordinator {
    private let initializeGameUseCase: InitializeGameUseCase
    private let calculateNextQuestionUseCase: CalculateNextQuestionUseCase
    private let processUserAnswerUseCase: ProcessUserAnswerUseCase
    private let validateHonestyUseCase: ValidateHonestyUseCase
    private let repository: MindReaderRepositoryProtocol
    
    // MARK: - Game State
    
    var gameState: MindReaderGameState?
    var currentQuestion: QuestionAttribute?
    var bestGuess: MindReaderWord?
    var popQuiz: PopQuizQuestion?
    var trapResult: TrapValidationResult?
    var allWords: [MindReaderWord] = []
    var availableWorlds: [MindReaderWorld] = []
    var questionCount: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    
    /// Shows the native translation after the user pays coins
    var translationRevealed: Bool = false
    
    init(
        initializeGameUseCase: InitializeGameUseCase,
        calculateNextQuestionUseCase: CalculateNextQuestionUseCase,
        processUserAnswerUseCase: ProcessUserAnswerUseCase,
        validateHonestyUseCase: ValidateHonestyUseCase,
        repository: MindReaderRepositoryProtocol
    ) {
        self.initializeGameUseCase = initializeGameUseCase
        self.calculateNextQuestionUseCase = calculateNextQuestionUseCase
        self.processUserAnswerUseCase = processUserAnswerUseCase
        self.validateHonestyUseCase = validateHonestyUseCase
        self.repository = repository
    }
    
    // MARK: - Public API
    
    /// Loads available worlds for category selection on the intro screen.
    func loadWorlds() async {
        do {
            availableWorlds = try await repository.getWorlds()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Initializes a new game for the given world.
    func initializeGame(worldId: String) async {
        isLoading = true
        errorMessage = nil
        translationRevealed = false
        
        do {
            let state = try await initializeGameUseCase.execute(worldId: worldId)
            gameState = state
            allWords = state.candidateWords
            questionCount = 0
            
            // Calculate the first question
            let result = calculateNextQuestionUseCase.execute(gameState: state)
            currentQuestion = result.nextQuestion
            bestGuess = result.bestGuess
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Processes the user's answer and calculates the next question or triggers the guess phase.
    /// Returns `true` if the guess threshold has been reached.
    func processAnswer(answer: AnswerState) -> Bool {
        guard let state = gameState, let question = currentQuestion else { return false }
        
        // Process the answer through the use case
        let updatedState = processUserAnswerUseCase.execute(
            gameState: state,
            attributeId: question.id,
            answer: answer
        )
        gameState = updatedState
        questionCount += 1
        translationRevealed = false
        
        // Calculate next question
        let result = calculateNextQuestionUseCase.execute(gameState: updatedState)
        currentQuestion = result.nextQuestion
        bestGuess = result.bestGuess
        
        return result.shouldTriggerGuessPhase
    }
    
    /// Generates a pop quiz for the "Yes, you got it!" flow.
    func generatePopQuiz() {
        guard let guess = bestGuess else { return }
        popQuiz = validateHonestyUseCase.generatePopQuiz(
            guessedWord: guess,
            allWords: allWords
        )
    }
    
    /// Validates the pop quiz answer. Returns the result.
    func validatePopQuiz(selectedOption: String) -> TrapValidationResult {
        guard let quiz = popQuiz, let state = gameState else {
            let result = TrapValidationResult.busted(reason: L10n.MindReader.bustedQuizFailed)
            trapResult = result
            return result
        }
        
        let result = validateHonestyUseCase.validatePopQuiz(
            selectedOption: selectedOption,
            popQuiz: quiz,
            answerHistory: state.answerHistory
        )
        trapResult = result
        return result
    }
    
    /// Validates the give-up / "No, you're wrong" flow (Akinator Trap).
    func validateGiveUp(selectedWordId: String) -> TrapValidationResult {
        guard let state = gameState else {
            let result = TrapValidationResult.busted(reason: L10n.MindReader.bustedInvalidSelection)
            trapResult = result
            return result
        }
        
        let result = validateHonestyUseCase.validateAkinatorTrap(
            selectedWordId: selectedWordId,
            allWords: allWords,
            answerHistory: state.answerHistory
        )
        trapResult = result
        return result
    }
    
    /// Saves the game result to the repository.
    func saveResult() async {
        guard let state = gameState, let result = trapResult else { return }
        try? await repository.saveGameResult(worldId: state.selectedWorld.id, result: result)
    }
    
    /// Resets all game state for a new round.
    func reset() {
        gameState = nil
        currentQuestion = nil
        bestGuess = nil
        popQuiz = nil
        trapResult = nil
        allWords = []
        questionCount = 0
        isLoading = false
        errorMessage = nil
        translationRevealed = false
    }
}
