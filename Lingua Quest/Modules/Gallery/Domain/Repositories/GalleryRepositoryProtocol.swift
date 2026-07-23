//
//  GalleryRepositoryProtocol.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation

protocol GalleryRepositoryProtocol {
    func getCapturedItems() async throws -> [CapturedItem]
    func saveCapturedItem(_ item: CapturedItem) async throws
    func getInsight(for word: WordCardEntity) async -> Result<AIWordInsightEntity, WordInsightError>
}
