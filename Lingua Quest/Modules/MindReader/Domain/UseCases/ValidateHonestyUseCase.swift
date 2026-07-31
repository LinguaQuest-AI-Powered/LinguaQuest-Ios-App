

import Foundation

struct ValidateHonestyUseCase: Sendable {
    init() {}
    
    func generatePopQuiz(
        guessedWord: MindReaderWord,
        allWords: [MindReaderWord]
    ) -> PopQuizQuestion {
        let correctTranslation = guessedWord.wordNativeLanguage
        
        let distractors = allWords
            .filter { $0.id != guessedWord.id }
            .map { $0.wordNativeLanguage }
            .shuffled()
            .prefix(3)
        
        var options = Array(distractors)
        options.append(correctTranslation)
        options.shuffle()
        
        return PopQuizQuestion(
            targetWord: guessedWord,
            correctTranslation: correctTranslation,
            options: options
        )
    }
    
    func validatePopQuiz(
        selectedOption: String,
        popQuiz: PopQuizQuestion,
        answerHistory: [String: AnswerState]
    ) -> TrapValidationResult {
        guard selectedOption == popQuiz.correctTranslation else {
            return .busted(reason: L10n.MindReader.bustedQuizFailed)
        }
        
        if let contradictionReason = checkContradictions(
            targetWord: popQuiz.targetWord,
            answerHistory: answerHistory
        ) {
            return .busted(reason: contradictionReason)
        }
        
        return .victory(coinsEarned: 20, xpEarned: 50, isStumpedBonus: false)
    }
    
    func validateAkinatorTrap(
        selectedWordId: String,
        allWords: [MindReaderWord],
        answerHistory: [String: AnswerState]
    ) -> TrapValidationResult {
        guard let selectedWord = allWords.first(where: { $0.id == selectedWordId }) else {
            return .busted(reason: L10n.MindReader.bustedInvalidSelection)
        }
        
        if let contradictionReason = checkContradictions(
            targetWord: selectedWord,
            answerHistory: answerHistory
        ) {
            return .busted(reason: contradictionReason)
        }
        
        return .victory(coinsEarned: 50, xpEarned: 100, isStumpedBonus: true)
    }
    
    // MARK: - Reverse Contradiction Engine
    
    private func checkContradictions(
        targetWord: MindReaderWord,
        answerHistory: [String: AnswerState]
    ) -> String? {
        var contradictionCount = 0
        var firstContradictionAttribute: String?
        
        for (attributeId, answer) in answerHistory {
            guard let trueWeight = targetWord.attributeWeights[attributeId] else { continue }
            
            if answer == .yes && trueWeight <= 0.15 {
                contradictionCount += 1
                if firstContradictionAttribute == nil {
                    firstContradictionAttribute = attributeId
                }
            } else if answer == .no && trueWeight >= 0.85 {
                contradictionCount += 1
                if firstContradictionAttribute == nil {
                    firstContradictionAttribute = attributeId
                }
            }
        }
        
        if contradictionCount >= 1 {
            return L10n.MindReader.bustedContradiction
        }
        
        return nil
    }
}
