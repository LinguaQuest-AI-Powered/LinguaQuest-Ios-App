//
//  SettingsFooterSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsFooterSection: View {
    // MARK: - Properties
    var onSaveChangesTapped: () -> Void
    var onLogOutTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            
            CustomButton(
                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                text: L10n.Settings.saveChanges,
                action: onSaveChangesTapped
            )
                        
            Button(action: onLogOutTapped) {
                Text(L10n.Settings.logOut)
                    .appTextStyle(.bodyBold, color: .appRed)
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Preview
#Preview {
    SettingsFooterSection(onSaveChangesTapped: {}, onLogOutTapped: {})
        .padding()
        .background(Color.appBackgroundWarm)
}
