

import Foundation

public struct QuestionAttribute: Identifiable, Equatable, Hashable, Sendable {
    public let id: String
    public let promptTargetLanguage: String
    public let promptNativeLanguage: String
    public let audioUrl: String?
    public var informationGain: Double
    
    public init(
        id: String,
        promptTargetLanguage: String,
        promptNativeLanguage: String,
        audioUrl: String? = nil,
        informationGain: Double = 0.0
    ) {
        self.id = id
        self.promptTargetLanguage = promptTargetLanguage
        self.promptNativeLanguage = promptNativeLanguage
        self.audioUrl = audioUrl
        self.informationGain = informationGain
    }
}
