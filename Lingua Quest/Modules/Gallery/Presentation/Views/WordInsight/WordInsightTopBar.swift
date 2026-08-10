//
//  WordInsightTopBar.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct WordInsightTopBar: View {
    // MARK: - Properties
    var onBackTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            CustomBackButton(action: onBackTapped)
            
            Spacer()
            
            // Invisible view for balancing
            Color.clear.frame(width: 44, height: 44)
        }
        .overlay(
            Text(L10n.WordInsight.title)
                .appTextStyle(.headingLarge, color: .appTextHeading)
        )
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
    WordInsightTopBar(onBackTapped: {})
        .background(Color.appBackgroundWarm)
}
