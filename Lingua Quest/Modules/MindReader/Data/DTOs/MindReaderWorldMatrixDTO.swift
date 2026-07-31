

import Foundation

public struct MindReaderWorldDTO: Codable, Sendable {
    public let id: String?
    public let name: String?
    public let icon: String?
    public let isUnlocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case isUnlocked = "is_unlocked"
    }
}

public struct MindReaderWorldMatrixDTO: Codable, Sendable {
    public let world: MindReaderWorldDTO?
    public let words: [MindReaderWordDTO]?
    public let attributes: [QuestionAttributeDTO]?
}

public struct MindReaderWorldsResponseDTO: Codable, Sendable {
    public let worlds: [MindReaderWorldDTO]?
    public let matrices: [MindReaderWorldMatrixDTO]?
}
