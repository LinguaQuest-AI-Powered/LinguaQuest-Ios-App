//
//  ErrorView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Reusable error state with retry action, used across screens
struct ErrorView: View {
    // MARK: - Properties
    let message: String
    let onRetry: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Image(systemIcon: .infoCircleFill)
                .font(.system(size: 32))
                .foregroundColor(.appRed)
            
            Text(message)
                .appTextStyle(.bodyMedium, color: .appTextSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                Text(L10n.Common.retry)
                    .appTextStyle(.bodyBold, color: .appBrandBrown)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview
#Preview {
    ErrorView(message: "Couldn't get AI review. Please try again.", onRetry: {})
        .background(Color.appBackgroundWarm)
}
