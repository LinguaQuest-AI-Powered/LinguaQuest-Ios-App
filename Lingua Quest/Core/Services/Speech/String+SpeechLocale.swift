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
        return AppLanguage.speechCode(for: self)
    }
}
