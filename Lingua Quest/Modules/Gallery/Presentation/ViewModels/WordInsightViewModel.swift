//
//  WordInsightViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import Observation
import SwiftUI

@Observable
@MainActor
final class WordInsightViewModel {
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let getWordInsightUseCase: GetWordInsightUseCaseProtocol
    private let speechSynthesizer: SpeechSynthesizerProtocol
    
    // MARK: - State
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var word: WordCardEntity? = nil
    var insight: AIWordInsightEntity? = nil
    var speakingSectionID: InsightSectionID? = nil
    
    // MARK: - Init
    init(
        router: RouterProtocol,
        getWordInsightUseCase: GetWordInsightUseCaseProtocol,
        speechSynthesizer: SpeechSynthesizerProtocol
    ) {
        self.router = router
        self.getWordInsightUseCase = getWordInsightUseCase
        self.speechSynthesizer = speechSynthesizer
        
        self.speechSynthesizer.onFinishSpeaking = { [weak self] in
            self?.speakingSectionID = nil
        }
    }
    
    // MARK: - UI Models
    var insightSections: [InsightSectionConfig] {
        guard let insight, let word else { return [] }
        
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
                speechLanguage: word.targetLanguage,
                accentColor: .appTextHeading,
                backgroundColor: .appSurfaceCardMuted.opacity(0.5)
            ),
            InsightSectionConfig(
                id: .funFact,
                emoji: "✨",
                label: L10n.WordInsight.funFactLabel,
                content: insight.funFact,
                speechLanguage: word.targetLanguage,
                accentColor: .appAccentTeal,
                backgroundColor: .appAccentTeal.opacity(0.08)
            )
        ]
    }
    
    // MARK: - Intentions
    func fetchInsight(for word: WordCardEntity) {
        self.word = word
        isLoading = true
        errorMessage = nil
        insight = nil
        
        Task {
            let result = await getWordInsightUseCase.execute(for: word)
            
            switch result {
            case .success(let insight):
                self.insight = insight
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            
            self.isLoading = false
        }
    }
    
    func retry() {
        guard let word else { return }
        fetchInsight(for: word)
    }
    
    func toggleSpeaking(for config: InsightSectionConfig) {
        if speakingSectionID == config.id {
            speakingSectionID = nil
            speechSynthesizer.stop()
        } else {
            speakingSectionID = config.id
            speechSynthesizer.speak(text: config.content, languageCode: config.speechLanguage)
        }
    }
    
    func onBackTapped() {
        speechSynthesizer.stop()
        router.pop()
    }
}
