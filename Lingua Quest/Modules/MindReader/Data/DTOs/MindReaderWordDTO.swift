

import Foundation

public struct MindReaderWordDTO: Codable, Sendable {
    public let id: String?
    public let wordTargetLanguage: String?
    public let wordNativeLanguage: String?
    public let emoji: String?
    public let categoryId: String?
    public let audioUrl: String?
    public let attributeWeights: [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case wordTargetLanguage = "word_target_language"
        case wordNativeLanguage = "word_native_language"
        case emoji
        case categoryId = "category_id"
        case audioUrl = "audio_url"
        case attributeWeights = "attribute_weights"
    }
}
