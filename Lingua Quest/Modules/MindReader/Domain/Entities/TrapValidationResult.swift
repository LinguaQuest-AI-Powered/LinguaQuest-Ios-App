

import Foundation

public enum TrapValidationResult: Equatable, Sendable {
    case victory(coinsEarned: Int, xpEarned: Int, isStumpedBonus: Bool)
    case busted(reason: String)
}
