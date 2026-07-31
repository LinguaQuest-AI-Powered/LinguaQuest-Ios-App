

import Foundation

public struct PopQuizQuestion: Equatable, Sendable {
    public let targetWord: MindReaderWord
    public let correctTranslation: String
    public let options: [String]
    
    public init(targetWord: MindReaderWord, correctTranslation: String, options: [String]) {
        self.targetWord = targetWord
        self.correctTranslation = correctTranslation
        self.options = options
    }
}
