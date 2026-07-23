//
//  DailyReminderSection.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct DailyReminderSection: View {
    @Binding var dailyReminderEnabled: Bool
    @Binding var reminderTime: Date
    let repeatText: String
    
    var onRepeatTapped: () -> Void
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsGroupLabel(title: L10n.Settings.dailyReminder)
            
            VStack(spacing: 0) {
                LinguaSettingsRow(
                    icon: .bellFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.dailyReminder,
                    showDivider: true
                ) {
                    LinguaCustomToggle(isOn: $dailyReminderEnabled)
                }
                
                LinguaSettingsRow(
                    icon: .bellFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.reminderTime,
                    showDivider: true
                ) {
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "en_US_POSIX"))
                }
                
                LinguaSettingsRow(
                    icon: .bellFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.repeatFrequency,
                    showDivider: false
                ) {
                    HStack(spacing: 8) {
                        Text(repeatText)
                            .appTextStyle(.bodyMedium, color: .appTextHeading)
                        SettingsRowChevron()
                    }
                }
                .onTapGesture(perform: onRepeatTapped)
            }
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
        }
    }
}
