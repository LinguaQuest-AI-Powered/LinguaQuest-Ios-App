

import Foundation

protocol GetContinueLevelUseCaseProtocol {
    func execute() async throws -> ContinueLevelEntity?
}

struct GetContinueLevelUseCase: GetContinueLevelUseCaseProtocol {
    private let repository: GameRepositoryProtocol

    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> ContinueLevelEntity? {
        try await repository.getContinueLevel()
    }
}
