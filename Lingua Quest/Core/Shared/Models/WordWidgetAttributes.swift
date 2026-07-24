//
//  WordWidgetAttributes.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import Foundation
import ActivityKit

struct WordWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var wordId: String
        var word: String
        var meaning: String
        var difficulty: String
        var targetLanguage: String
        var localizedAppName: String
        var localizedTapToOpen: String
        var localizedDifficulty: String
        var localizedTargetLanguage: String
        var isDarkMode: Bool
        var isAppArabic: Bool
    }
}
