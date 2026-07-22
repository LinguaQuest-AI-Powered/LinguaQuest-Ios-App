//
//  CompleteProfileUseCase.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation

protocol CompleteProfileUseCaseProtocol {
    func execute(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError>
}

struct CompleteProfileUseCase: CompleteProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(nativeLanguageId: Int, targetLanguageId: Int, username: String?) async -> Result<(session: AuthSessionEntity, user: UserEntity, profileComplete: Bool), AuthError> {
        do {
            let result = try await repository.completeProfile(
                nativeLanguageId: nativeLanguageId,
                targetLanguageId: targetLanguageId,
                username: username
            )
            return .success(result)
        } catch let error as AuthError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}
