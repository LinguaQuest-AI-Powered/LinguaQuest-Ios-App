//
//  GetHomeDataUseCase.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

protocol GetHomeDataUseCaseProtocol {
    func execute() async throws -> HomeData
}

struct GetHomeDataUseCase: GetHomeDataUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> HomeData {
        return try await repository.getHomeData()
    }
}
