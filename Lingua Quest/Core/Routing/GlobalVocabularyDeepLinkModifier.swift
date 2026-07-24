//
//  GlobalVocabularyDeepLinkModifier.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct GlobalVocabularyDeepLinkModifier: ViewModifier {
    @State private var showDialog: Bool = false
    @State private var selectedWord: VocabularyWordEntity? = nil
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("VocabularyNotificationTapped"))) { notification in
                if let wordId = notification.userInfo?["wordId"] as? UUID {
                    fetchAndShowWord(wordId: wordId)
                }
            }
            .appDialog(isPresented: $showDialog) {
                if let word = selectedWord {
                    VocabularyWordDetailDialog(
                        word: word,
                        onSpeakTapped: {
                            Resolver.shared.resolve(SpeechSynthesizerProtocol.self).speak(text: word.word, languageCode: word.targetLanguage)
                        },
                        onDismiss: {
                            showDialog = false
                            selectedWord = nil
                        }
                    )
                } else {
                    EmptyView()
                }
            }
    }
    
    private func fetchAndShowWord(wordId: UUID) {
        Task {
            let useCase = Resolver.shared.resolve(GetSavedVocabularyWordsUseCaseProtocol.self)
            let markAddedUseCase = Resolver.shared.resolve(MarkWordAsAddedToJournalUseCaseProtocol.self)
            
            do {
                try await markAddedUseCase.execute(id: wordId)
                
                let words = try await useCase.execute()
                if let word = words.first(where: { $0.id == wordId }) {
                    DispatchQueue.main.async {
                        self.selectedWord = word
                        self.showDialog = true
                    }
                }
            } catch {
                print("Failed to fetch word for deep link: \(error)")
            }
        }
    }
}

extension View {
    func globalVocabularyDeepLink() -> some View {
        modifier(GlobalVocabularyDeepLinkModifier())
    }
}
