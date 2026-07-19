//
//  SettingsMascotSection.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct SettingsMascotSection: View {
    // MARK: - Properties
    let userName: String
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            Image(asset: .mascotSettings)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .padding(.bottom, 8)
            
            Text(userName)
                .appTextStyle(.displayLarge, color: .appTextHeading)
            
            Text(L10n.Settings.subtitle)
                .appTextStyle(.bodyLarge, color: .appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    SettingsMascotSection(userName: "Explorer Alex")
        .padding()
        .background(Color.appBackgroundWarm)
}
