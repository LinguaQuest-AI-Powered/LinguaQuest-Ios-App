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
    var onAppLanguageTapped: () -> Void
    var onHelpTapped: () -> Void
    var onAboutTapped: () -> Void
    var onLogOutTapped: () -> Void
    var onRepeatTapped: () -> Void
    
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
                            onEditProfileTapped: onEditProfileTapped,
                            onLearningLanguageTapped: onLearningLanguageTapped
                        )
                        
                        AppExperienceSection(
                            appLanguage: viewModel.appLanguage,
                            notificationsEnabled: $viewModel.notificationsEnabled,
                            darkModeEnabled: $viewModel.darkModeEnabled,
                            soundEffectsEnabled: $viewModel.soundEffectsEnabled,
                            onAppLanguageTapped: onAppLanguageTapped,
                            onHelpTapped: onHelpTapped,
                            onAboutTapped: onAboutTapped
                        )
                        
                        DailyReminderSection(
                            dailyReminderEnabled: $viewModel.dailyReminderEnabled,
                            reminderTime: $viewModel.reminderTime,
                            repeatText: viewModel.getRepeatDaysText(),
                            onRepeatTapped: onRepeatTapped
                        )
                        
                        SettingsFooterSection(
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
