

import Foundation

public struct MindReaderGameState: Equatable, Sendable {
    public var selectedWorld: MindReaderWorld
    public var candidateWords: [MindReaderWord]
    public var availableAttributes: [QuestionAttribute]
    public var askedAttributeIds: [String]
    public var answerHistory: [String: AnswerState]
    public var currentBestGuess: MindReaderWord?
    public var isGuessThresholdReached: Bool
    
    public init(
        selectedWorld: MindReaderWorld,
        candidateWords: [MindReaderWord],
        availableAttributes: [QuestionAttribute],
        askedAttributeIds: [String] = [],
        answerHistory: [String: AnswerState] = [:],
        currentBestGuess: MindReaderWord? = nil,
        isGuessThresholdReached: Bool = false
    ) {
        self.selectedWorld = selectedWorld
        self.candidateWords = candidateWords
        self.availableAttributes = availableAttributes
        self.askedAttributeIds = askedAttributeIds
        self.answerHistory = answerHistory
        self.currentBestGuess = currentBestGuess
        self.isGuessThresholdReached = isGuessThresholdReached
    }
}
