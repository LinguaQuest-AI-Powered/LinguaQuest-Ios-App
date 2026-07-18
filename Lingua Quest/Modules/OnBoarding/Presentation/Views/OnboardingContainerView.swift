//
//  OnboardingContainerView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel = Resolver.shared.resolve(OnboardingViewModel.self)
    var body: some View {
        NavigationStack {
            Group {
            switch viewModel.state.currentStep {
            case .welcome:
                WelcomeStepView(
                    onGetStarted: viewModel.onGetStartedTapped,
                    onLogin: viewModel.onLoginTapped
                )

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
}

#Preview("LightTheme") {
    OnboardingContainerView()
}

#Preview("DarkTheme") {
    OnboardingContainerView()
        .preferredColorScheme(.dark)
}
