//
//  WordInsightView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct WordInsightView: View {
    // MARK: - Properties
    let word: WordCardEntity
    var onBackTapped: () -> Void = {}
    
    @State private var viewModel = WordInsightViewModel()
    
    // MARK: - Body
    var body: some View {
        WordInsightContentView(
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            word: viewModel.word,
            speakingSectionID: viewModel.speakingSectionID,
            insightSections: viewModel.insightSections,
            onBackTapped: onBackTapped,
            onRetryTapped: { viewModel.retry() },
            onSpeakSection: { config in viewModel.toggleSpeaking(for: config) }
        )
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchInsight(for: word)
        }
    }
}

// MARK: - Preview
#Preview {
    WordInsightView(
        word: WordCardEntity(
            id: "1",
            sourceWord: "Apple",
            translatedWord: "تفاحة",
            sourceLanguage: "English",
            targetLanguage: "Arabic",
            category: "Food",
            imagePath: ""
        ),
        onBackTapped: {}
    )
}
