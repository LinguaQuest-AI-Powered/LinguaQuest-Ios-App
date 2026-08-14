//
//  ProfileCompletionViewModel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileCompletionViewModel {
    private(set) var state = OnboardingUiState()
    private var userPreferences: UserPreferences
    private let router: RouterProtocol
    private let getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase
    private let completeProfileUseCase: CompleteProfileUseCaseProtocol
    
    var isLoading: Bool = false
    var errorMessage: String? = nil

    init(
        router: RouterProtocol,
        userPreferences: UserPreferences,
        getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase,
        completeProfileUseCase: CompleteProfileUseCaseProtocol
    ) {
        self.router = router
        self.userPreferences = userPreferences
        self.getAvailableLanguagesUseCase = getAvailableLanguagesUseCase
        self.completeProfileUseCase = completeProfileUseCase
        // Skip welcome step, go straight to language selection
        self.state.currentStep = .language
        fetchTargetLanguages()
    }

    private func fetchTargetLanguages() {
        guard state.targetLanguages.isEmpty else { return }
        state.isLoadingTargetLanguages = true
        Task {
            do {
                let languages = try await getAvailableLanguagesUseCase.execute()
                await MainActor.run {
                    self.state.targetLanguages = languages
                    self.state.isLoadingTargetLanguages = false
                }
            } catch {
                await MainActor.run {
                    self.state.isLoadingTargetLanguages = false
                }
            }
        }
    }

    func onBackTapped() {
        switch state.currentStep {
        case .welcome, .language:
            if userPreferences.isLoggedIn {
                router.popToRoot() 
            } else {
                router.pop()
            }
        case .level:
            state.currentStep = .language
        }
    }

    func onSpokenLanguageSelected(_ language: AppLanguage) {
        state.selectedSpokenLanguage = language
    }

    func onLearningLanguageSelected(_ language: AvailableLanguage) {
        state.selectedLearningLanguage = language
    }

    func onLanguageContinueTapped() {
        guard state.canContinueFromLanguage else { return }
        state.currentStep = .level
    }

    func onLevelSelected(_ level: UserLevel) {
        state.selectedLevel = level
    }

    func onFinishTapped() {
        guard state.canContinueFromLevel else { return }
        
        userPreferences.spokenLanguageCode = state.selectedSpokenLanguage?.code
        userPreferences.learningLanguageCode = state.selectedLearningLanguage?.code
        userPreferences.userLevel = state.selectedLevel?.rawValue
        
        if userPreferences.isLoggedIn {
            guard let spokenCode = state.selectedSpokenLanguage?.code,
                  let learningCode = state.selectedLearningLanguage?.code else { return }
            
            isLoading = true
            errorMessage = nil
            
            Task {
                do {
                    // Fetch available languages from the backend
                    let availableLanguages = try await getAvailableLanguagesUseCase.execute()
                    
                    // Map local string codes to backend integer IDs
                    // Backend uses 2-letter codes, same as our local generator.
                    guard let nativeLangId = availableLanguages.first(where: { $0.code == spokenCode })?.id,
                          let targetLangId = availableLanguages.first(where: { $0.code == learningCode })?.id else {
                        throw AuthError.unknown("Selected language is not supported by the backend.")
                    }
                    
                    // Complete profile using the retrieved IDs
                    let result = await completeProfileUseCase.execute(
                        nativeLanguageId: nativeLangId,
                        targetLanguageId: targetLangId,
                        username: nil // Username is collected later or handled via other means
                    )
                    
                    isLoading = false
                    
                    switch result {
                    case .success:
                        userPreferences.needsProfileCompletion = false
                    case .failure(let error):
                        if case .profileAlreadyCompleted = error {
                            userPreferences.needsProfileCompletion = false
                        } else {
                            errorMessage = error.errorDescription
                        }
                    }
                } catch {
                    isLoading = false
                    errorMessage = (error as? AuthError)?.errorDescription ?? error.localizedDescription
                }
            }
        } else {
            // Pre-Registration (skipped onboarding)
            // Push SignUp so user can go back to language/level if needed
            router.push(.signUp)
        }
    }
}
