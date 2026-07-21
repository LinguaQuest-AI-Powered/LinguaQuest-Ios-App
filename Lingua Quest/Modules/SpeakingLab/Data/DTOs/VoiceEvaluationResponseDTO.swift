//
//  VoiceEvaluationResponseDTO.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

struct VoiceEvaluationResponseDTO: Codable {
    let rating: Int
    let correct_words: [String]
    let wrong_words: [String]
    let advice: String
}
