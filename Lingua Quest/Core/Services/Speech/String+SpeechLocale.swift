//
//  String+SpeechLocale.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Foundation

extension String {
    /// Maps a human-readable language name (as stored in WordCardEntity) to a BCP-47 code usable by AVSpeechSynthesisVoice
    func toSpeechLanguageCode() -> String {
        switch trimmingCharacters(in: .whitespaces).lowercased() {
        case "arabic", "ar": return "ar-SA"
        case "spanish", "español", "es": return "es-ES"
        case "japanese", "日本語", "ja": return "ja-JP"
        case "german", "deutsch", "de": return "de-DE"
        case "french", "français", "fr": return "fr-FR"
        case "chinese", "中文", "zh": return "zh-CN"
        case "italian", "italiano", "it": return "it-IT"
        case "portuguese", "português", "pt": return "pt-PT"
        case "korean", "한국어", "ko": return "ko-KR"
        default: return "en-US"
        }
    }
}
