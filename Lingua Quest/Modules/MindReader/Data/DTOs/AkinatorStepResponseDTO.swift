//
//  AkinatorStepResponseDTO.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct AkinatorStepResponseDTO: Decodable {
    let type: String
    let questionTargetText: String?
    let questionNativeText: String?
    let guessWordTargetLanguage: String?
    let guessWordNativeLanguage: String?
    let guessEmoji: String?
}
