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
    @State var viewModel: WordInsightViewModel
    
    // MARK: - Init
    init(viewModel: WordInsightViewModel, word: WordCardEntity) {
        self.viewModel = viewModel
        self.word = word
    }
    
    // MARK: - Body
    var body: some View {
        WordInsightContentView(
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            word: viewModel.word,
            speakingSectionID: viewModel.speakingSectionID,
            insightSections: viewModel.insightSections,
            onBackTapped: { viewModel.onBackTapped() },
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
        viewModel: WordInsightViewModel(
            router: Router(),
            getWordInsightUseCase: GetWordInsightUseCase(
                repository: GalleryRepositoryImpl(
                    remoteDataSource: WordInsightRemoteDataSource(),
                    userPreferences: UserPreferences()
                )
            ),
            speechSynthesizer: AVSpeechSynthesizerService()
        ),
        word: WordCardEntity(
            id: "1",
            sourceWord: "Apple",
            translatedWord: "تفاحة",
            sourceLanguage: "English",
            targetLanguage: "Arabic",
            category: "Food",
            imagePath: ""
        )
    )
}
