//
//  MindReaderCategoriesLocalDataSourceProtocol.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

protocol MindReaderCategoriesLocalDataSourceProtocol {
    func fetchCategories() -> [GameCategoryDTO]
}
