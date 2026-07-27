//
//  LanguageEntities.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

struct MyTargetLanguage: Identifiable, Equatable {
    let id: Int
    let name: String
    let code: String
    let level: Int
    let isActive: Bool
    let progressPercent: Int
    
    var flagEmoji: String {
        return code.languageFlagEmoji
    }
}

struct AvailableLanguage: Identifiable, Equatable {
    let id: Int
    let name: String
    let code: String
    let isAdded: Bool
    
    var flagEmoji: String {
        return code.languageFlagEmoji
    }
}
