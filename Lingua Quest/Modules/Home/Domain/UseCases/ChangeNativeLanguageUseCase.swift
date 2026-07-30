//
//  ChangeNativeLanguageUseCase.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 30/07/2026.
//

import Foundation

protocol ChangeNativeLanguageUseCaseProtocol {
    func execute(languageId: Int) async throws
}

struct ChangeNativeLanguageUseCase: ChangeNativeLanguageUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(languageId: Int) async throws {
        try await repository.changeNativeLanguage(languageId: languageId)
    }
}
