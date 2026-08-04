//
//  LanguageUseCases.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct GetMyLanguagesUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [MyTargetLanguage] {
        return try await repository.getMyLanguages()
    }
}

struct GetAvailableLanguagesUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [AvailableLanguage] {
        return try await repository.getAvailableLanguages()
    }
}

struct SwitchActiveLanguageUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(languageId: Int) async throws -> MyTargetLanguage {
        return try await repository.switchActiveLanguage(languageId: languageId)
    }
}

struct AddLanguagesUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(languageIds: [Int]) async throws -> [MyTargetLanguage] {
        return try await repository.addLanguages(languageIds: languageIds)
    }
}

struct RemoveLanguagesUseCase {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(languageIds: [Int]) async throws -> [MyTargetLanguage] {
        return try await repository.removeLanguages(languageIds: languageIds)
    }
}
