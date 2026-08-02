//
//  MindReaderCategoriesLocalDataSource.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

class MindReaderCategoriesLocalDataSource: MindReaderCategoriesLocalDataSourceProtocol {
    func fetchCategories() -> [GameCategoryDTO] {
        guard let url = Bundle.main.url(forResource: "MindReaderCategories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([GameCategoryDTO].self, from: data)
        } catch {
            print("Failed to decode categories: \(error)")
            return []
        }
    }
}
