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
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 10)
                }
            }
        }
        .alert(L10n.Common.error, isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button(L10n.Common.ok, role: .cancel) { }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}
