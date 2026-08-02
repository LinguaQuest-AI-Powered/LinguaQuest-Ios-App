//
//  VerifyHonestyUseCase.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct VerifyHonestyUseCase {
    let repository: MindReaderRepositoryProtocol
    
    func execute(category: GameCategory, history: [GameTurn], claimedWord: String) async throws -> HonestyVerdict {
        return try await repository.verifyHonesty(
            category: category,
            history: history,
            claimedWord: claimedWord
        )
    }
}
