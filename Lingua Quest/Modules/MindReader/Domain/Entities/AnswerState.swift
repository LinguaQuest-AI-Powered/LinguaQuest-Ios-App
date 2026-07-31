

import Foundation

public enum AnswerState: String, Codable, Sendable, CaseIterable {
    case yes
    case no
    case sometimes
    case probablyNot
    case dontKnow
    
   
    public func weightMultiplier(for attributeWeight: Double) -> Double {
        switch self {
        case .yes:
            return attributeWeight
        case .no:
            return 1.0 - attributeWeight
        case .sometimes:
            return 0.5 + (attributeWeight - 0.5) * 0.5
        case .probablyNot:
            return 0.2 + (1.0 - attributeWeight) * 0.6
        case .dontKnow:
            return 0.5
        }
    }
}
