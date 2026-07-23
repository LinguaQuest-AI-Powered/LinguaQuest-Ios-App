//
//  InsightSectionConfig.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Drives the rendering of each AI insight card — avoids repeating
/// four near-identical blocks in the content view.
struct InsightSectionConfig: Identifiable {
    let id: InsightSectionID
    let emoji: String
    let label: String
    let content: String
    let speechLanguage: String
    let accentColor: Color
    let backgroundColor: Color
    var isItalic: Bool = false
}
