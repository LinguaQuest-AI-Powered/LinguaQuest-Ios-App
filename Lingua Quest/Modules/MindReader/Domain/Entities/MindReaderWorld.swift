

import Foundation

public struct MindReaderWorld: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let icon: String
    public let isUnlocked: Bool
    
    public init(id: String, name: String, icon: String, isUnlocked: Bool = true) {
        self.id = id
        self.name = name
        self.icon = icon
        self.isUnlocked = isUnlocked
    }
}
