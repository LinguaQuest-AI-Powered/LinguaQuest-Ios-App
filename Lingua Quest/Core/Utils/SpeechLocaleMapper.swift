//
//  SpeechLocaleMapper.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import Foundation
import AVFoundation

struct SpeechLocaleMapper {
    /// Maps a simple language code (e.g. "en", "es") or name ("english", "spanish") to a BCP-47 speech code (e.g. "en-US") supported by AVSpeechSynthesizer.
    static func mapToSpeechCode(_ code: String) -> String {
        let normalizedCode = code.lowercased()
        
        // Preferred common mappings for standard dialects
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
        
        // Fallback: dynamically search available voices in the system
        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        if let matchedVoice = allVoices.first(where: { $0.language.lowercased().starts(with: normalizedCode) }) {
            return matchedVoice.language
        }
        
        return "en-US"
    }
}
