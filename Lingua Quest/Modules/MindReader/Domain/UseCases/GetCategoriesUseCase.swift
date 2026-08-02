//
//  GetCategoriesUseCase.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct GetCategoriesUseCase {
    let repository: MindReaderRepositoryProtocol
    
    func execute() -> [GameCategory] {
        return repository.fetchCategories()
    }
}
