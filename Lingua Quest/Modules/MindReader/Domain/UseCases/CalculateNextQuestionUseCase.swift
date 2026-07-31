

import Foundation

struct CalculateNextQuestionUseCase: Sendable {
    private let confidenceThreshold: Double
    
    init(confidenceThreshold: Double = 0.80) {
        self.confidenceThreshold = confidenceThreshold
    }
    
    struct Result: Sendable {
        let nextQuestion: QuestionAttribute?
        let bestGuess: MindReaderWord?
        let shouldTriggerGuessPhase: Bool
    }
    
    func execute(gameState: MindReaderGameState) -> Result {
        let candidates = gameState.candidateWords
        
        guard !candidates.isEmpty else {
            return Result(nextQuestion: nil, bestGuess: nil, shouldTriggerGuessPhase: true)
        }
        
        let sortedCandidates = candidates.sorted { $0.probability > $1.probability }
        let topCandidate = sortedCandidates.first
        
        if let top = topCandidate, (top.probability >= confidenceThreshold || candidates.count <= 1) {
            return Result(nextQuestion: nil, bestGuess: top, shouldTriggerGuessPhase: true)
        }
        
        let unaskedAttributes = gameState.availableAttributes.filter {
            !gameState.askedAttributeIds.contains($0.id)
        }
        
        guard !unaskedAttributes.isEmpty else {
            return Result(nextQuestion: nil, bestGuess: topCandidate, shouldTriggerGuessPhase: true)
        }
        
        let currentEntropy = calculateEntropy(candidates: candidates)
        
        var bestAttribute: QuestionAttribute?
        var maxInformationGain: Double = -Double.greatestFiniteMagnitude
        
        for attribute in unaskedAttributes {
            let ig = calculateInformationGain(
                attributeId: attribute.id,
                candidates: candidates,
                currentEntropy: currentEntropy
            )
            
            if ig > maxInformationGain {
                maxInformationGain = ig
                var scoredAttribute = attribute
                scoredAttribute.informationGain = ig
                bestAttribute = scoredAttribute
            }
        }
        
        let triggerGuess = (bestAttribute == nil || maxInformationGain <= 0.001)
        
        return Result(
            nextQuestion: bestAttribute,
            bestGuess: topCandidate,
            shouldTriggerGuessPhase: triggerGuess
        )
    }
    
    // MARK: - Algorithmic Calculations
    
    private func calculateEntropy(candidates: [MindReaderWord]) -> Double {
        let totalProb = candidates.reduce(0.0) { $0 + $1.probability }
        guard totalProb > 0 else { return 0.0 }
        
        var entropy: Double = 0.0
        for word in candidates {
            let p = word.probability / totalProb
            if p > 0 {
                entropy -= p * log2(p)
            }
        }
        return entropy
    }
    
    private func calculateInformationGain(
        attributeId: String,
        candidates: [MindReaderWord],
        currentEntropy: Double
    ) -> Double {
        let totalProb = candidates.reduce(0.0) { $0 + $1.probability }
        guard totalProb > 0 else { return 0.0 }
        
        var pYes: Double = 0.0
        var pNo: Double = 0.0
        
        for word in candidates {
            let weight = word.attributeWeights[attributeId] ?? 0.5
            let normP = word.probability / totalProb
            pYes += normP * weight
            pNo += normP * (1.0 - weight)
        }
        
        let pYesTotal = pYes
        let pNoTotal = pNo
        
        guard pYesTotal > 0, pNoTotal > 0 else { return 0.0 }
        
        var entropyYes: Double = 0.0
        var entropyNo: Double = 0.0
        
        for word in candidates {
            let weight = word.attributeWeights[attributeId] ?? 0.5
            let normP = word.probability / totalProb
            
            let pConditionalYes = (normP * weight) / pYesTotal
            if pConditionalYes > 0 {
                entropyYes -= pConditionalYes * log2(pConditionalYes)
            }
            
            let pConditionalNo = (normP * (1.0 - weight)) / pNoTotal
            if pConditionalNo > 0 {
                entropyNo -= pConditionalNo * log2(pConditionalNo)
            }
        }
        
        let expectedEntropyAfterQuestion = (pYesTotal * entropyYes) + (pNoTotal * entropyNo)
        return currentEntropy - expectedEntropyAfterQuestion
    }
}
