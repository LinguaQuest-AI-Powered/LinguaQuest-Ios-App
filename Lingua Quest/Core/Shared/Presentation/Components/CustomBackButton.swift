//
//  CustomBackButton.swift
//  Lingua Quest
//
//  Created by siam on 16/07/2026.
//

import SwiftUI
struct CustomBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.appSurfaceCardMuted)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemIcon: .chevronLeft)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appBrandPrimary)
                        .flipsForRightToLeftLayoutDirection(true)
                )
        }
    
    }
}

#Preview {
    CustomBackButton(action: { print("Back tapped") })
        .padding()
}

