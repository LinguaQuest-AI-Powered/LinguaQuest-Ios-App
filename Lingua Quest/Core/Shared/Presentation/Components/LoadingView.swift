//
//  LoadingView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Reusable loading state used across screens
struct LoadingView: View {
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.3)
            
            Text(L10n.Common.loading)
                .appTextStyle(.captionMedium, color: .appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Preview
#Preview {
    LoadingView()
        .background(Color.appBackgroundWarm)
}
