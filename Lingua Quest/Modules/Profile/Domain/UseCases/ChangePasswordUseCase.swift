

import Foundation

protocol ChangePasswordUseCaseProtocol {
    func execute(oldPassword: String, newPassword: String) async throws
}

final class ChangePasswordUseCase: ChangePasswordUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(oldPassword: String, newPassword: String) async throws {
        try await repository.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
}
