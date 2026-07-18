//
//  WordHeroCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Hero image header showing the captured word, its translation,
/// category, and language pair
struct WordHeroCard: View {
    // MARK: - Properties
    let word: WordCardEntity
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: word.imagePath)) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Color.appBorderLight
                }
            }
            .frame(height: 240)
            .clipped()
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(word.sourceWord)
                        .appTextStyle(.headingLarge, color: .white)
                    Text(word.translatedWord)
                        .appTextStyle(.bodyMedium, color: .white.opacity(0.85))
                }
                
                Spacer()
                
                LanguagePairBadge(
                    sourceLanguage: word.sourceLanguage,
                    targetLanguage: word.targetLanguage
                )
            }
            .padding(16)
        }
        .frame(height: 240)
        .overlay(alignment: .topTrailing) {
            CategoryBadge(title: word.category)
                .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Preview
#Preview {
    WordHeroCard(
        word: WordCardEntity(
            id: "1",
            sourceWord: "Apple",
            translatedWord: "تفاحة",
            sourceLanguage: "English",
            targetLanguage: "Arabic",
            category: "Food",
            imagePath: ""
        )
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
