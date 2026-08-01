//
//  Int+Ext.swift
//  Lingua Quest
//
//  Created by siam on 30/07/2026.
//

import Foundation

extension Int {
    func formattedStatsValue() -> String {
        let locale = Locale(identifier: "en_US")
        if self >= 1_000_000 {
            let formatted = String(format: "%.1fM", locale: locale, Double(self) / 1_000_000)
            return formatted.replacingOccurrences(of: ".0M", with: "M")
        } else if self >= 1_000 {
            let formatted = String(format: "%.1fk", locale: locale, Double(self) / 1_000)
            return formatted.replacingOccurrences(of: ".0k", with: "k")
        } else {
            return String(format: "%d", locale: locale, self)
        }
    }
}
