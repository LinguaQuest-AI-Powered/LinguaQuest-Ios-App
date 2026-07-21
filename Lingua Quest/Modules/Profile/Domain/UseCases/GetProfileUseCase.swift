//
//  GetProfileUseCase.swift
//  Lingua Quest
//
//  Created by Al3dwy on 20/07/2026.
//

import Foundation

protocol GetProfileUseCaseProtocol {
    func execute() async throws -> UserProfileEntity
}

final class GetProfileUseCase: GetProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserProfileEntity {
        return try await repository.getProfile()
    }
}
