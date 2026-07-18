//
//  SettingsView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct LinguaSettingsView: View {
    // MARK: - Properties
    @State private var viewModel = SettingsViewModel()
    
    // MARK: - Body
    var body: some View {
        SettingsContentView(
            viewModel: viewModel,
            onBackTapped: {
                // Navigate back
            },
            onEditProfileTapped: {
                // Navigate to Edit Profile
            },
            onLearningLanguageTapped: {
                // Navigate to Language Picker
            },
            onDailyGoalTapped: {
                // Navigate to Daily Goal Picker
            },
            onLearningStreakTapped: {
                // Navigate to Streak Details
            },
            onPrivacyTapped: {
                // Navigate to Privacy & Security
            },
            onHelpTapped: {
                // Navigate to Help & Support
            },
            onAboutTapped: {
                // Navigate to About App
            },
            onSaveChangesTapped: {
                viewModel.saveChanges()
            },
            onLogOutTapped: {
                viewModel.logOut()
            }
        )
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    LinguaSettingsView()
}
