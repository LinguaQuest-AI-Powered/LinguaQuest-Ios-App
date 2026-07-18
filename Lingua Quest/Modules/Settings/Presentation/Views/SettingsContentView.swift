//
//  LinguaSettingsContentView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsContentView: View {
    // MARK: - Properties
    @Bindable var viewModel: SettingsViewModel
    
    var onBackTapped: () -> Void
    var onEditProfileTapped: () -> Void
    var onLearningLanguageTapped: () -> Void
    var onDailyGoalTapped: () -> Void
    var onLearningStreakTapped: () -> Void
    var onPrivacyTapped: () -> Void
    var onHelpTapped: () -> Void
    var onAboutTapped: () -> Void
    var onSaveChangesTapped: () -> Void
    var onLogOutTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                SettingsAppBar(onBackTapped: onBackTapped)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        SettingsMascotSection(userName: viewModel.userName)
                        
                        AccountJourneySection(
                            learningLanguage: viewModel.learningLanguage,
                            dailyGoal: viewModel.dailyGoal,
                            learningStreak: viewModel.learningStreak,
                            onEditProfileTapped: onEditProfileTapped,
                            onLearningLanguageTapped: onLearningLanguageTapped,
                            onDailyGoalTapped: onDailyGoalTapped,
                            onLearningStreakTapped: onLearningStreakTapped
                        )
                        
                        AppExperienceSection(
                            notificationsEnabled: $viewModel.notificationsEnabled,
                            darkModeEnabled: $viewModel.darkModeEnabled,
                            soundEffectsEnabled: $viewModel.soundEffectsEnabled,
                            onPrivacyTapped: onPrivacyTapped,
                            onHelpTapped: onHelpTapped,
                            onAboutTapped: onAboutTapped
                        )
                        
                        SettingsFooterSection(
                            onSaveChangesTapped: onSaveChangesTapped,
                            onLogOutTapped: onLogOutTapped
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsContentView(
        viewModel: SettingsViewModel(),
        onBackTapped: {},
        onEditProfileTapped: {},
        onLearningLanguageTapped: {},
        onDailyGoalTapped: {},
        onLearningStreakTapped: {},
        onPrivacyTapped: {},
        onHelpTapped: {},
        onAboutTapped: {},
        onSaveChangesTapped: {},
        onLogOutTapped: {}
    )
}
