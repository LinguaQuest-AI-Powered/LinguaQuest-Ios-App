//
//  SettingsGroupLabel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct SettingsGroupLabel: View {
    // MARK: - Properties
    let title: String
    
    // MARK: - Body
    var body: some View {
        Text(title)
            .appTextStyle(.captionBold, color: .appTextSecondary)
            .padding(.horizontal, 8)
    }
}

// MARK: - Preview
#Preview {
    SettingsGroupLabel(title: L10n.Settings.accountJourney)
}
