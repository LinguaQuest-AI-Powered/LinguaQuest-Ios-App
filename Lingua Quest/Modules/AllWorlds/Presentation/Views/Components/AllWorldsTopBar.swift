//
//  AllWorldsTopBar.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct AllWorldsTopBar: View {
    var onBackTapped: () -> Void
    
    var body: some View {
        ZStack {
            Text(L10n.Components.appName)
                .appTextStyle(.headingMediumBold, color: .appBrandBrownDark)
            
            HStack {
                CustomBackButton(action: onBackTapped)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
    }
}

// MARK: - Preview
#Preview {
    AllWorldsTopBar(onBackTapped: {})
        .background(Color.appBackgroundWarm)
}
