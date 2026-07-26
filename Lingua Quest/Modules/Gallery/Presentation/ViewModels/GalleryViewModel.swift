//
//  GalleryViewModel.swift
//  Lingua Quest
//
//  Created by taqieallah on 22/07/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class GalleryViewModel {
    private let getCapturedItemsUseCase: GetCapturedItemsUseCase
    private let saveCapturedItemUseCase: SaveCapturedItemUseCase
    private let getSavedVocabularyWordsUseCase: GetSavedVocabularyWordsUseCaseProtocol?
    private let speechSynthesizer: SpeechSynthesizerProtocol?
    private let router: RouterProtocol
    private let userPreferences: UserPreferencesProtocol
    
    var items: [CapturedItem] = []
    var vocabularyWords: [VocabularyWordEntity] = []
    
    var selectedDifficultyFilter: String? = nil
    
    var isLockScreenVocabularyEnabled: Bool {
        userPreferences.isLockScreenVocabularyEnabled
    }
    
    var filteredVocabularyWords: [VocabularyWordEntity] {
        vocabularyWords.filter { word in
            let added = word.isAddedToJournal
            if let filter = selectedDifficultyFilter {
                return added && word.difficulty.lowercased() == filter.lowercased()
            }
            return added
        }
    }
    
    var selectedVocabularyWord: VocabularyWordEntity? = nil
    var showVocabularyDialog: Bool = false
    
    init(getCapturedItemsUseCase: GetCapturedItemsUseCase,
         saveCapturedItemUseCase: SaveCapturedItemUseCase,
         getSavedVocabularyWordsUseCase: GetSavedVocabularyWordsUseCaseProtocol? = nil,
         speechSynthesizer: SpeechSynthesizerProtocol? = nil,
         router: RouterProtocol,
         userPreferences: UserPreferencesProtocol) {
        self.getCapturedItemsUseCase = getCapturedItemsUseCase
        self.saveCapturedItemUseCase = saveCapturedItemUseCase
        self.getSavedVocabularyWordsUseCase = getSavedVocabularyWordsUseCase
        self.speechSynthesizer = speechSynthesizer
        self.router = router
        self.userPreferences = userPreferences
    }
    
    func onWordTapped(_ item: CapturedItem) {
        let word = WordCardEntity(
            id: item.id.uuidString,
            sourceWord: item.englishName,
            translatedWord: item.translatedName,
            sourceLanguage: userPreferences.spokenLanguageCode ?? "en-US",
            targetLanguage: userPreferences.learningLanguageCode ?? "es-ES",
            category: item.category,
            imagePath: "",
            imageData: item.imageData,
            // Fallback to "apple" if no image data or asset exists (matching Gallery UI)
            imageAsset: item.image ?? (item.imageData == nil ? "apple" : nil)
        )
        router.push(.wordInsight(word: word))
    }
    
    func onVocabularyWordTapped(_ word: VocabularyWordEntity) {
        selectedVocabularyWord = word
        showVocabularyDialog = true
    }
    
    func onSpeakTapped(_ word: VocabularyWordEntity) {
        speechSynthesizer?.speak(text: word.word, languageCode: word.targetLanguage)
    }
    
    func loadItems() {
        Task {
            do {
                let fetchedItems = try await getCapturedItemsUseCase.execute()
                self.items = fetchedItems
                
                if let getSavedVocabularyWordsUseCase = getSavedVocabularyWordsUseCase {
                    let fetchedWords = try await getSavedVocabularyWordsUseCase.execute()
                    self.vocabularyWords = fetchedWords
                }
            } catch {
                print("Error loading captured items: \(error)")
            }
        }
    }
    
}
