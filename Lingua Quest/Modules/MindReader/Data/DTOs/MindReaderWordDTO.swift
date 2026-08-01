

import Foundation

public struct MindReaderWordDTO: Codable, Sendable {
    public let id: String?
    public let wordTargetLanguage: String?
    public let wordNativeLanguage: String?
    public let emoji: String?
    public let categoryId: String?
    public let audioUrl: String?
    public let attributeWeights: [String: Double]?
    
}
