//
//  VoiceSentence.swift
//  Lingua Quest
//
//  Created by siam on 21/07/2026.
//

import Foundation

struct VoiceSentence: Identifiable, Equatable, Hashable {
    let id: String
    let text: String
    let difficulty: String
    let language: String
}
