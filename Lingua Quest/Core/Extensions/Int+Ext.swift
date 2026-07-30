//
//  Int+Ext.swift
//  Lingua Quest
//
//  Created by siam on 30/07/2026.
//

import Foundation

extension Int {
    func formattedStatsValue() -> String {
        if self >= 1_000_000 {
            let formatted = String(format: "%.1fM", Double(self) / 1_000_000)
            return formatted.replacingOccurrences(of: ".0M", with: "M")
        } else if self >= 1_000 {
            let formatted = String(format: "%.1fk", Double(self) / 1_000)
            return formatted.replacingOccurrences(of: ".0k", with: "k")
        } else {
            return "\(self)"
        }
    }
}
