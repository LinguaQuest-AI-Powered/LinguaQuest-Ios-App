//
//  VoiceEvaluationResult.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

struct VoiceEvaluationResult: Equatable, Hashable {
    let rating: Int
    let correctWords: [String]
    let wrongWords: [String]
    let advice: String
}
