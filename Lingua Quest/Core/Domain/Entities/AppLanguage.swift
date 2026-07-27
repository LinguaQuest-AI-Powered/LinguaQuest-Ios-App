//
//  AppLanguage.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"
    case german = "de"
    case italian = "it"
    case spanish = "es"
    case russian = "ru"
    
    var id: String { rawValue }
    var code: String { rawValue }
    
    var name: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        case .german: return "Deutsch"
        case .italian: return "Italiano"
        case .spanish: return "Español"
        case .russian: return "Русский"
        }
    }
    
    var flag: String {
        return self.rawValue.languageFlagEmoji
    }
}
