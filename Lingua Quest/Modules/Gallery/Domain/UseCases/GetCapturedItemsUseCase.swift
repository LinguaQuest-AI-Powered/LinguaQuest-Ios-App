//
//  GetCapturedItemsUseCase.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation

class GetCapturedItemsUseCase {
    private let repository: GalleryRepositoryProtocol
    
    init(repository: GalleryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [CapturedItem] {
        return try await repository.getCapturedItems()
    }
}
