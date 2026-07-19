//
//  AccountJourneySection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct AccountJourneySection: View {
    // MARK: - Properties
    let learningLanguage: String
    let dailyGoal: String
    let learningStreak: String
    
    var onEditProfileTapped: () -> Void
    var onLearningLanguageTapped: () -> Void
    var onDailyGoalTapped: () -> Void
    var onLearningStreakTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsGroupLabel(title: L10n.Settings.accountJourney)
            
            VStack(spacing: 0) {
                LinguaSettingsRow(
                    icon: .personFill,
                    iconBgColor: .appAccentOrange,
                    title: L10n.Settings.editProfile,
                    showDivider: true
                ) {
                    SettingsRowChevron()
                }
                .onTapGesture(perform: onEditProfileTapped)
                
                LinguaSettingsRow(
                    icon: .globe,
                    iconBgColor: .appAccentOrange,
                    title: L10n.Settings.learningLanguage,
                    showDivider: true
                ) {
                    SettingsRowValue(value: learningLanguage)
                }
                .onTapGesture(perform: onLearningLanguageTapped)
                
                LinguaSettingsRow(
                    icon: .target,
                    iconBgColor: .appAccentOrange,
                    title: L10n.Settings.dailyGoal,
                    showDivider: true
                ) {
                    SettingsRowValue(value: dailyGoal)
                }
                .onTapGesture(perform: onDailyGoalTapped)
                
                LinguaSettingsRow(
                    icon: .flameFill,
                    iconBgColor: .appAccentOrange,
                    title: L10n.Settings.learningStreak,
                    showDivider: false
                ) {
                    SettingsRowValue(value: learningStreak)
                }
                .onTapGesture(perform: onLearningStreakTapped)
            }
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
        }
    }
}

// MARK: - Preview
#Preview {
    AccountJourneySection(
        learningLanguage: "Spanish",
        dailyGoal: "15 mins",
        learningStreak: "12 Days",
        onEditProfileTapped: {},
        onLearningLanguageTapped: {},
        onDailyGoalTapped: {},
        onLearningStreakTapped: {}
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
