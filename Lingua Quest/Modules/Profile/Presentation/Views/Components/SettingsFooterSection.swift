//
//  SettingsFooterSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsFooterSection: View {
    // MARK: - Properties
    var onLogOutTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            CustomButton(
                type: .custom(textColor: .appTextSelectedBrown, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                text: L10n.Settings.logOut,
                action: onLogOutTapped
            )
        }
        .padding(.top, 16)
    }
}

// MARK: - Preview
#Preview {
    SettingsFooterSection(onLogOutTapped: {})
        .padding()
        .background(Color.appBackgroundWarm)
}
