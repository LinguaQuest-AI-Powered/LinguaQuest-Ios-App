

import Foundation

protocol UploadProfilePhotoUseCaseProtocol {
    func execute(imageData: Data, mimeType: String) async throws -> String
}

final class UploadProfilePhotoUseCase: UploadProfilePhotoUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(imageData: Data, mimeType: String) async throws -> String {
        return try await repository.uploadPhoto(imageData: imageData, mimeType: mimeType)
    }
}
