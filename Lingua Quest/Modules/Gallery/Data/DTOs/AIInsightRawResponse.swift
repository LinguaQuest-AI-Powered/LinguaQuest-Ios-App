//
//  AIInsightRawResponse.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

/// Raw JSON shape returned by the AI model, decoded before mapping to the domain entity.
struct AIInsightRawResponse: Decodable {
    let sentence: String
    let translation: String
    let tip: String
    let fact: String
}
