

import Foundation

protocol UpdateProfileUseCaseProtocol {
    func execute(username: String) async throws -> String
}

final class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(username: String) async throws -> String {
        return try await repository.updateProfile(username: username)
    }
}
