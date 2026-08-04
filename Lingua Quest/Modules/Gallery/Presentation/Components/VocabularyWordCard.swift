//
//  VocabularyWordCard.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct VocabularyWordCard: View {
    let word: VocabularyWordEntity
    let onSpeakTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(localizedDifficulty)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor.opacity(0.2))
                    .foregroundColor(difficultyColor)
                    .clipShape(Capsule())
                
                Spacer()
                
                Button(action: onSpeakTapped) {
                    Image(systemIcon: .speakerWave2Fill)
                        .foregroundColor(.appBrandPrimary)
                        .padding(8)
                        .background(Color.appBrandPrimary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            Spacer(minLength: 0)
            
            Text(word.word)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .multilineTextAlignment(.center)
            
            Text(word.meaning)
                .appTextStyle(.bodyMedium, color: .appTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.appSurfaceCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var difficultyColor: Color {
        switch word.difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .appBrandPrimary
        }
    }
    
    private var localizedDifficulty: String {
        switch word.difficulty.lowercased() {
        case "easy": return L10n.Home.difficultyEasy
        case "medium": return L10n.Home.difficultyMedium
        case "hard": return L10n.Home.difficultyHard
        default: return word.difficulty
        }
    }
}
