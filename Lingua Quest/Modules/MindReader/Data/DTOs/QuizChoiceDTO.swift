//
//  QuizChoiceDTO.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct QuizChoiceWrapperDTO: Decodable {
    let choices: [QuizChoiceDTO]
}

struct QuizChoiceDTO: Decodable {
    let translationText: String
    let isCorrect: Bool
}
