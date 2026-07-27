//
//  AppLanguage.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import Foundation
import AVFoundation

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
        return AppLanguage.getFlagEmoji(for: self.rawValue)
    }
    
    // MARK: - Central Utilities
   
    static func getFlagEmoji(for code: String) -> String {
        let codeMapping: [String: String] = [
            "en": "US", "ja": "JP", "zh": "CN", "ko": "KR", "es": "ES",
            "fr": "FR", "de": "DE", "it": "IT", "pt": "PT", "ru": "RU",
            "ar": "SA", "tr": "TR", "hi": "IN", "nl": "NL"
        ]
        
        let regionCode = codeMapping[code.lowercased()] ?? code.uppercased()
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in regionCode.unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { continue }
            flagString.unicodeScalars.append(scalarValue)
        }
        return flagString
    }
    
   
    static func speechCode(for code: String) -> String {
        let normalizedCode = code.lowercased()
        
        let commonMappings: [String: String] = [
            "ar": "ar-SA", "arabic": "ar-SA",
            "de": "de-DE", "german": "de-DE",
            "en": "en-US", "english": "en-US",
            "es": "es-ES", "spanish": "es-ES",
            "fr": "fr-FR", "french": "fr-FR",
            "it": "it-IT", "italian": "it-IT",
            "ja": "ja-JP", "japanese": "ja-JP",
            "ko": "ko-KR", "korean": "ko-KR",
            "pt": "pt-BR", "portuguese": "pt-BR",
            "ru": "ru-RU", "russian": "ru-RU",
            "tr": "tr-TR", "turkish": "tr-TR",
            "zh": "zh-CN", "chinese": "zh-CN"
        ]
        
        if let mapped = commonMappings[normalizedCode] {
            return mapped
        }
        
        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        if let matchedVoice = allVoices.first(where: { $0.language.lowercased().starts(with: normalizedCode) }) {
            return matchedVoice.language
        }
        
        return "en-US"
    }
}

extension String {
    var languageFlagEmoji: String {
        return AppLanguage.getFlagEmoji(for: self)
    }
}

extension AppLanguage {
    static let targetLanguages: [AvailableLanguage] = [
        AvailableLanguage(id: 10, name: "Arabic", code: "ar", isAdded: true),
        AvailableLanguage(id: 8, name: "Chinese", code: "zh", isAdded: true),
        AvailableLanguage(id: 1, name: "English", code: "en", isAdded: true),
        AvailableLanguage(id: 3, name: "French", code: "fr", isAdded: false),
        AvailableLanguage(id: 4, name: "German", code: "de", isAdded: true),
        AvailableLanguage(id: 5, name: "Italian", code: "it", isAdded: true),
        AvailableLanguage(id: 7, name: "Japanese", code: "ja", isAdded: true),
        AvailableLanguage(id: 9, name: "Korean", code: "ko", isAdded: false),
        AvailableLanguage(id: 6, name: "Portuguese", code: "pt", isAdded: false),
        AvailableLanguage(id: 2, name: "Spanish", code: "es", isAdded: false)
    ]
}
