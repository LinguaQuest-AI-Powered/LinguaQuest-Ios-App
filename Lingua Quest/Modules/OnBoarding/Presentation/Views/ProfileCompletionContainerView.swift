//
//  ProfileCompletionContainerView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 22/07/2026.
//

import SwiftUI

struct ProfileCompletionContainerView: View {
    @State private var viewModel: ProfileCompletionViewModel
    
    init(viewModel: ProfileCompletionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.state.currentStep {
            case .welcome:
                // Should not happen as we start at .language
                EmptyView()

            case .language:
                LanguageStepView(
                    state: viewModel.state,
                    onSelectSpokenLanguage: viewModel.onSpokenLanguageSelected,
                    onSelectLearningLanguage: viewModel.onLearningLanguageSelected,
                    onContinue: viewModel.onLanguageContinueTapped,
                    onBack: viewModel.onBackTapped
                )

            case .level:
                LevelStepView(
                    state: viewModel.state,
                    onSelectLevel: viewModel.onLevelSelected,
                    onContinue: viewModel.onFinishTapped,
                    onBack: viewModel.onBackTapped
                )
            }
        }
        .animation(.easeInOut, value: viewModel.state.currentStep)
    }
}
