//
//  LanguagePairBadge.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Shows "Source → Target" language pair, used over dark backgrounds
struct LanguagePairBadge: View {
    // MARK: - Properties
    let sourceLanguage: String
    let targetLanguage: String
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 4) {
            Text(sourceLanguage)
            Image(systemIcon: .arrowRight)
                .font(.system(size: 9, weight: .bold))
            Text(targetLanguage)
        }
        .appTextStyle(.microSemibold, color: .white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.18))
        .cornerRadius(10)
    }
}

// MARK: - Preview
#Preview {
    LanguagePairBadge(sourceLanguage: "English", targetLanguage: "Arabic")
        .padding()
        .background(Color.appBrandBrownDark)
}
