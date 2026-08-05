//
//  VocabularyWordDetailDialog.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct VocabularyWordDetailDialog: View {
    let word: VocabularyWordEntity
    let onSpeakTapped: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        DialogCardContainer {
            VStack(spacing: 24) {
                // Header (Speak + Difficulty)
                HStack {
                    Button(action: onSpeakTapped) {
                        Image(systemIcon: .speakerWave2Fill)
                            .foregroundColor(.appBrandPrimary)
                            .padding(12)
                            .background(Color.appBrandPrimary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(localizedDifficulty.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(difficultyColor.opacity(0.2))
                        .foregroundColor(difficultyColor)
                        .clipShape(Capsule())
                }
                
                // Words
                VStack(spacing: 8) {
                    Text(word.word)
                        .dialogTitleStyle()
                        .multilineTextAlignment(.center)
                    
                    Text(word.meaning)
                        .dialogTitleStyle()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Example Sentence
                VStack(spacing: 8) {
                    Text(L10n.WordInsight.exampleLabel)
                        .dialogSubtitleStyle()
                    
                    Text(word.exampleSentence)
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.appBackgroundWarm)
                .cornerRadius(12)
                
                // Close Action
                CustomButton(
                    type: .primary,
                    text: L10n.Common.ok,
                    action: { onDismiss() }
                )
            }
        }
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
