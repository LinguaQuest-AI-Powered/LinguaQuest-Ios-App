//
//  WorldsCountLabel.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct WorldsCountLabel: View {
    let count: Int
    
    var body: some View {
        Text(L10n.Worlds.worldsCountFormat(count))
            .appTextStyle(.captionBold, color: .appTextSecondary)
    }
}

// MARK: - Preview
#Preview {
    WorldsCountLabel(count: 6)
        .padding()
        .background(Color.appBackgroundWarm)
}
