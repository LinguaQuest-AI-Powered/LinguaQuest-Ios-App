//
//  AIGameDecision.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

enum AIGameDecision: Equatable {
    case question(targetText: String, nativeText: String)
    case guess(word: String, translation: String, emoji: String)
}
