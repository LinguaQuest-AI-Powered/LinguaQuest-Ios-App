//
//  LanguageViewModel.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 21/07/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class LanguageViewModel {
    private let getMyLanguagesUseCase: GetMyLanguagesUseCase
    private let getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase
    private let switchActiveLanguageUseCase: SwitchActiveLanguageUseCase
    private let addLanguagesUseCase: AddLanguagesUseCase
    private let activateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol
    private var userPreferences: UserPreferences
    
    // Callbacks
    var onLanguageSwitched: (() -> Void)?
    
    // State
    var myLanguages: [MyTargetLanguage] = []
    var availableLanguages: [AvailableLanguage] = []
    var selectedLanguageId: Int?
    
    var isLoadingMyLanguages = false
    var isLoadingAvailableLanguages = false
    var isSwitchingLanguage = false
    var isAddingLanguages = false
    
    var errorMessage: String?
    
    var activeLanguage: MyTargetLanguage? {
        myLanguages.first(where: { $0.isActive })
    }
    
    init(
        getMyLanguagesUseCase: GetMyLanguagesUseCase,
        getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase,
        switchActiveLanguageUseCase: SwitchActiveLanguageUseCase,
        addLanguagesUseCase: AddLanguagesUseCase,
        activateLockScreenVocabularyUseCase: ActivateLockScreenVocabularyUseCaseProtocol,
        userPreferences: UserPreferences
    ) {
        self.getMyLanguagesUseCase = getMyLanguagesUseCase
        self.getAvailableLanguagesUseCase = getAvailableLanguagesUseCase
        self.switchActiveLanguageUseCase = switchActiveLanguageUseCase
        self.addLanguagesUseCase = addLanguagesUseCase
        self.activateLockScreenVocabularyUseCase = activateLockScreenVocabularyUseCase
        self.userPreferences = userPreferences
    }
    
    func loadMyLanguages(forceRefresh: Bool = false) async {
        if myLanguages.isEmpty || forceRefresh {
            isLoadingMyLanguages = true
        }
        errorMessage = nil
        do {
            myLanguages = try await getMyLanguagesUseCase.execute()
            if selectedLanguageId == nil {
                selectedLanguageId = activeLanguage?.id
            }
            
            // Sync to UserPreferences on initial load
            if let active = activeLanguage {
                userPreferences.learningLanguageCode = active.code
                userPreferences.targetLanguageName = active.name
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load my languages: \(error)")
        }
        isLoadingMyLanguages = false
    }
    
    func loadAvailableLanguages() async {
        isLoadingAvailableLanguages = true
        errorMessage = nil
        do {
            availableLanguages = try await getAvailableLanguagesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load available languages: \(error)")
        }
        isLoadingAvailableLanguages = false
    }
    
    func switchActiveLanguage(to languageId: Int) async {
        guard languageId != activeLanguage?.id else { return }
        
        isSwitchingLanguage = true
        errorMessage = nil
        do {
            _ = try await switchActiveLanguageUseCase.execute(languageId: languageId)
            // Update local state to reflect the switch, bypassing dummy backend hardcoded values
            for i in myLanguages.indices {
                myLanguages[i] = MyTargetLanguage(
                    id: myLanguages[i].id,
                    name: myLanguages[i].name,
                    code: myLanguages[i].code,
                    level: myLanguages[i].level,
                    isActive: myLanguages[i].id == languageId,
                    progressPercent: myLanguages[i].progressPercent
                )
            }
            selectedLanguageId = languageId
            
            // Sync to UserPreferences
            if let active = activeLanguage {
                userPreferences.learningLanguageCode = active.code
                userPreferences.targetLanguageName = active.name
                
                if userPreferences.isLockScreenVocabularyEnabled {
                    Task {
                        _ = await activateLockScreenVocabularyUseCase.execute()
                    }
                }
            }
            
            onLanguageSwitched?()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to switch active language: \(error)")
            // Revert selected language id on failure
            selectedLanguageId = activeLanguage?.id
        }
        isSwitchingLanguage = false
    }
    
    func addLanguages(languageIds: [Int]) async {
        isAddingLanguages = true
        errorMessage = nil
        do {
            _ = try await addLanguagesUseCase.execute(languageIds: languageIds)
            await loadMyLanguages()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to add languages: \(error)")
        }
        isAddingLanguages = false
    }
}
