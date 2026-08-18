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
    case spanish = "es"
    case french = "fr"
    case german = "de"
    
    var id: String { rawValue }
    var code: String { rawValue }
    
    var name: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
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
            "ar": "ar-SA", "arabic": "ar-SA", "ar-sa": "ar-SA", "ar-ae": "ar-AE", "ar-eg": "ar-EG",
            "de": "de-DE", "german": "de-DE", "de-de": "de-DE",
            "en": "en-US", "english": "en-US", "en-us": "en-US", "en-gb": "en-GB",
            "es": "es-ES", "spanish": "es-ES", "es-es": "es-ES", "es-mx": "es-MX",
            "fr": "fr-FR", "french": "fr-FR", "fr-fr": "fr-FR",
            "it": "it-IT", "italian": "it-IT", "it-it": "it-IT",
            "ja": "ja-JP", "japanese": "ja-JP", "ja-jp": "ja-JP",
            "ko": "ko-KR", "korean": "ko-KR", "ko-kr": "ko-KR",
            "pt": "pt-BR", "portuguese": "pt-BR", "pt-br": "pt-BR", "pt-pt": "pt-PT",
            "ru": "ru-RU", "russian": "ru-RU", "ru-ru": "ru-RU",
            "tr": "tr-TR", "turkish": "tr-TR", "tr-tr": "tr-TR",
            "zh": "zh-CN", "chinese": "zh-CN", "zh-cn": "zh-CN"
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
        AvailableLanguage(id: 1, name: "English", code: "en", isAdded: true),
        AvailableLanguage(id: 2, name: "Spanish", code: "es", isAdded: true),
        AvailableLanguage(id: 3, name: "French", code: "fr", isAdded: true),
        AvailableLanguage(id: 4, name: "German", code: "de", isAdded: true)
    ]
}
