//
//  SaveCapturedItemUseCase.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation

class SaveCapturedItemUseCase {
    private let repository: GalleryRepositoryProtocol
    
    init(repository: GalleryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(item: CapturedItem) async throws {
        try await repository.saveCapturedItem(item)
    }
}
