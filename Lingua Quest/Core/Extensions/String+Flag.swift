//
//  String+Flag.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import Foundation

extension String {
    var languageFlagEmoji: String {
        let codeMapping: [String: String] = [
            "en": "US",
            "ja": "JP",
            "zh": "CN",
            "ko": "KR",
            "es": "ES",
            "fr": "FR",
            "de": "DE",
            "it": "IT",
            "pt": "PT",
            "ru": "RU",
            "ar": "SA",
            "tr": "TR",
            "hi": "IN",
            "nl": "NL"
        ]
        
        let regionCode = codeMapping[self.lowercased()] ?? self.uppercased()
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in regionCode.unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { continue }
            flagString.unicodeScalars.append(scalarValue)
        }
        return flagString
    }
}
