

import Foundation

struct ProcessUserAnswerUseCase: Sendable {
    init() {}
    
    func execute(
        gameState: MindReaderGameState,
        attributeId: String,
        answer: AnswerState
    ) -> MindReaderGameState {
        var updatedState = gameState
        
        if !updatedState.askedAttributeIds.contains(attributeId) {
            updatedState.askedAttributeIds.append(attributeId)
        }
        updatedState.answerHistory[attributeId] = answer
        
        var updatedCandidates = updatedState.candidateWords.map { word -> MindReaderWord in
            var mutableWord = word
            let attributeWeight = word.attributeWeights[attributeId] ?? 0.5
            let multiplier = answer.weightMultiplier(for: attributeWeight)
            mutableWord.probability *= multiplier
            return mutableWord
        }
        
        updatedCandidates = updatedCandidates.filter { $0.probability > 0.0001 }
        
        let totalProbability = updatedCandidates.reduce(0.0) { $0 + $1.probability }
        if totalProbability > 0 {
            updatedCandidates = updatedCandidates.map { word in
                var mutableWord = word
                mutableWord.probability /= totalProbability
                return mutableWord
            }
        }
        
        updatedState.candidateWords = updatedCandidates
        
        let sorted = updatedCandidates.sorted { $0.probability > $1.probability }
        updatedState.currentBestGuess = sorted.first
        
        if let top = sorted.first, (top.probability >= 0.80 || updatedCandidates.count <= 1) {
            updatedState.isGuessThresholdReached = true
        }
        
        return updatedState
    }
}
