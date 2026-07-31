

import Foundation

public struct QuestionAttributeDTO: Codable, Sendable {
    public let id: String?
    public let promptTargetLanguage: String?
    public let promptNativeLanguage: String?
    public let audioUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case promptTargetLanguage = "prompt_target_language"
        case promptNativeLanguage = "prompt_native_language"
        case audioUrl = "audio_url"
    }
}
