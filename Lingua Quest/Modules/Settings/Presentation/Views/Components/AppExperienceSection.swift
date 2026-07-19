//
//  AppExperienceSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct AppExperienceSection: View {
    // MARK: - Properties
    @Binding var notificationsEnabled: Bool
    @Binding var darkModeEnabled: Bool
    @Binding var soundEffectsEnabled: Bool
    
    var onPrivacyTapped: () -> Void
    var onHelpTapped: () -> Void
    var onAboutTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsGroupLabel(title: L10n.Settings.appExperience)
            
            VStack(spacing: 0) {
                LinguaSettingsRow(
                    icon: .bellFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.notifications,
                    showDivider: true
                ) {
                    LinguaCustomToggle(isOn: $notificationsEnabled)
                }
                
                LinguaSettingsRow(
                    icon: .moonFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.darkMode,
                    showDivider: true
                ) {
                    LinguaCustomToggle(isOn: $darkModeEnabled)
                }
                
                LinguaSettingsRow(
                    icon: .speakerWave2Fill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.soundEffects,
                    showDivider: true
                ) {
                    LinguaCustomToggle(isOn: $soundEffectsEnabled)
                }
                
                LinguaSettingsRow(
                    icon: .lockFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.privacySecurity,
                    showDivider: true
                ) {
                    SettingsRowChevron()
                }
                .onTapGesture(perform: onPrivacyTapped)
                
                LinguaSettingsRow(
                    icon: .questionmarkCircleFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.helpSupport,
                    showDivider: true
                ) {
                    SettingsRowChevron()
                }
                .onTapGesture(perform: onHelpTapped)
                
                LinguaSettingsRow(
                    icon: .infoCircleFill,
                    iconBgColor: .appSemanticSuccess,
                    title: L10n.Settings.aboutApp,
                    showDivider: false
                ) {
                    SettingsRowChevron()
                }
                .onTapGesture(perform: onAboutTapped)
            }
            .background(Color.appSurfaceCard)
            .cornerRadius(20)
            .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var notifications = true
    @Previewable @State var darkMode = false
    @Previewable @State var sound = true
    
    return AppExperienceSection(
        notificationsEnabled: $notifications,
        darkModeEnabled: $darkMode,
        soundEffectsEnabled: $sound,
        onPrivacyTapped: {},
        onHelpTapped: {},
        onAboutTapped: {}
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
