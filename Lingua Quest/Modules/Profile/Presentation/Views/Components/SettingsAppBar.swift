//
//  LinguaSettingsAppBar.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct SettingsAppBar: View {
    // MARK: - Properties
    var onBackTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            CustomBackButton(action: onBackTapped)
            
            Spacer()
            
            Text(L10n.Settings.title)
                .appTextStyle(.headingLarge, color: .appTextHeading)
            
            Spacer()
            
            // Invisible view for balancing
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.appBorderBrown),
            alignment: .bottom
        )
    }
}

// MARK: - Preview
#Preview {
    SettingsAppBar(onBackTapped: {})
}
