//
//  WordInsightError.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

enum WordInsightError: Error, LocalizedError {
    case emptyResponse
    case parsingFailed
    case generationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return L10n.WordInsight.emptyResponseError
        case .parsingFailed:
            return L10n.WordInsight.parsingError
        case .generationFailed(let message):
            return message
        }
    }
}
