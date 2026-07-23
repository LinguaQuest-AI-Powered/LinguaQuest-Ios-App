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
        ZStack {
            Text(L10n.WordInsight.title)
                .appTextStyle(.headingMediumBold, color: .appTextHeading)
            
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
    WordInsightTopBar(onBackTapped: {})
        .background(Color.appBackgroundWarm)
}
