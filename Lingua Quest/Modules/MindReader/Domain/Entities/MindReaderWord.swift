

import Foundation

public struct MindReaderWord: Identifiable, Equatable, Sendable {
    public let id: String
    public let wordTargetLanguage: String
    public let wordNativeLanguage: String
    public let emoji: String
    public let categoryId: String
    public let audioUrl: String?
    public let attributeWeights: [String: Double]
    public var probability: Double
    
    public init(
        id: String,
        wordTargetLanguage: String,
        wordNativeLanguage: String,
        emoji: String,
        categoryId: String,
        audioUrl: String? = nil,
        attributeWeights: [String: Double],
        probability: Double = 0.0
    ) {
        self.id = id
        self.wordTargetLanguage = wordTargetLanguage
        self.wordNativeLanguage = wordNativeLanguage
        self.emoji = emoji
        self.categoryId = categoryId
        self.audioUrl = audioUrl
        self.attributeWeights = attributeWeights
        self.probability = probability
    }
}
