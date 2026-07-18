//
//  WordInsightViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation
import SwiftUI

@Observable
final class WordInsightViewModel {
    // MARK: - State
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var word: WordCardEntity? = nil
    var insight: AIWordInsightEntity? = nil
    var speakingSectionID: InsightSectionID? = nil
    
    // MARK: - UI Models
    /// Maps the raw AI response into ready-to-render UI section configs
    var insightSections: [InsightSectionConfig] {
        guard let insight = insight, let word = word else { return [] }
        
        return [
            InsightSectionConfig(
                id: .sentence,
                emoji: "📝",
                label: L10n.WordInsight.sentenceLabel,
                content: insight.exampleSentence,
                speechLanguage: word.sourceLanguage,
                accentColor: .appAccentOrange,
                backgroundColor: .appSurfaceCardWarm
            ),
            InsightSectionConfig(
                id: .translation,
                emoji: "🌍",
                label: L10n.WordInsight.translationLabel,
                content: insight.sentenceTranslation,
                speechLanguage: word.targetLanguage,
                accentColor: .appSemanticSuccess,
                backgroundColor: .appBadgeTealBg.opacity(0.4),
                isItalic: true
            ),
            InsightSectionConfig(
                id: .memory,
                emoji: "💡",
                label: L10n.WordInsight.memoryLabel,
                content: insight.memoryTip,
                speechLanguage: word.sourceLanguage,
                accentColor: .appTextHeading,
                backgroundColor: .appSurfaceCardMuted.opacity(0.5)
            ),
            InsightSectionConfig(
                id: .funFact,
                emoji: "✨",
                label: L10n.WordInsight.funFactLabel,
                content: insight.funFact,
                speechLanguage: word.sourceLanguage,
                accentColor: .appAccentTeal,
                backgroundColor: .appAccentTeal.opacity(0.08)
            )
        ]
    }
    
    // MARK: - Intentions (Methods)
    
    /// Mock fetch — will be replaced by the real use case once wired to Architecture layer
    func fetchInsight(for word: WordCardEntity) {
        self.word = word
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            
            await MainActor.run {
                self.insight = AIWordInsightEntity(
                    exampleSentence: "She ate a red apple for breakfast.",
                    sentenceTranslation: "أكلت تفاحة حمراء على الفطور.",
                    memoryTip: "Think of the apple emoji 🍎 – it starts the ABC, just like learning starts with basics.",
                    funFact: "There are more than 7,500 known cultivars of apples grown around the world."
                )
                self.isLoading = false
            }
        }
    }
    
    func retry() {
        guard let word else { return }
        fetchInsight(for: word)
    }
    
    func toggleSpeaking(for config: InsightSectionConfig) {
        speakingSectionID = (speakingSectionID == config.id) ? nil : config.id
        // TTS trigger will be added once the speech service is wired in
    }
}
