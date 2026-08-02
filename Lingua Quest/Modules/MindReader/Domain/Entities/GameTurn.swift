//
//  GameTurn.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct GameTurn: Equatable {
    let index: Int
    let questionTargetText: String
    let questionNativeText: String
    let answer: AnswerState
}
