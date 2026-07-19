//
//  WordInsightContentView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct WordInsightContentView: View {
    // MARK: - Properties
    let isLoading: Bool
    let errorMessage: String?
    let word: WordCardEntity?
    let speakingSectionID: InsightSectionID?
    
    // UI Model Array provided by ViewModel
    let insightSections: [InsightSectionConfig]
    
    var onBackTapped: () -> Void
    var onRetryTapped: () -> Void
    var onSpeakSection: (InsightSectionConfig) -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                WordInsightTopBar(onBackTapped: onBackTapped)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        stateContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private var stateContent: some View {
        if isLoading {
            LoadingView()
        } else if let errorMessage {
            ErrorView(message: errorMessage, onRetry: onRetryTapped)
        } else if let word {
            WordHeroCard(word: word)
            
            ForEach(insightSections) { config in
                InsightSectionCard(
                    config: config,
                    isSpeaking: speakingSectionID == config.id,
                    onSpeak: { onSpeakSection(config) }
                )
            }
        }
    }
}

// MARK: - Previews
#Preview("Loading") {
    WordInsightContentView(
        isLoading: true,
        errorMessage: nil,
        word: nil,
        speakingSectionID: nil,
        insightSections: [],
        onBackTapped: {},
        onRetryTapped: {},
        onSpeakSection: { _ in }
    )
}

#Preview("Error") {
    WordInsightContentView(
        isLoading: false,
        errorMessage: "Couldn't get AI review. Please try again.",
        word: nil,
        speakingSectionID: nil,
        insightSections: [],
        onBackTapped: {},
        onRetryTapped: {},
        onSpeakSection: { _ in }
    )
}

#Preview("Success") {
    let mockWord = WordCardEntity(
        id: "1", sourceWord: "Apple", translatedWord: "تفاحة",
        sourceLanguage: "English", targetLanguage: "Arabic",
        category: "Food", imagePath: ""
    )
    
    let mockConfigs = [
        InsightSectionConfig(id: .sentence, emoji: "📝", label: "Example Sentence", content: "She ate a red apple.", speechLanguage: "English", accentColor: .appAccentOrange, backgroundColor: .appSurfaceCardWarm),
        InsightSectionConfig(id: .translation, emoji: "🌍", label: "Translation", content: "أكلت تفاحة حمراء.", speechLanguage: "Arabic", accentColor: .appSemanticSuccess, backgroundColor: .appBadgeTealBg.opacity(0.4), isItalic: true)
    ]
    
    return WordInsightContentView(
        isLoading: false,
        errorMessage: nil,
        word: mockWord,
        speakingSectionID: .translation,
        insightSections: mockConfigs,
        onBackTapped: {},
        onRetryTapped: {},
        onSpeakSection: { _ in }
    )
}
