//
//  GameCategory.swift
//  Lingua Quest
//
//  Created by siam on 02/08/2026.
//

import Foundation

struct GameCategory: Equatable, Identifiable {
    let id: String
    let key: String
    let nativeName: String
    let targetName: String
    let emoji: String
    let promptContext: String
}
