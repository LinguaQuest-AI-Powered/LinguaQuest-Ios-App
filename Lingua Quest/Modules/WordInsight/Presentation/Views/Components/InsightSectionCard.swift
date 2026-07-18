//
//  InsightSectionCard.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct InsightSectionCard: View {
    // MARK: - Properties
    let config: InsightSectionConfig
    let isSpeaking: Bool
    let onSpeak: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(config.emoji)
                    .font(.system(size: 16))
                
                Text(config.label)
                    .appTextStyle(.microBold, color: config.accentColor)
                    .textCase(.uppercase)
                
                Spacer()
                
                SpeakButton(isSpeaking: isSpeaking, action: onSpeak)
            }
            
            Rectangle()
                .fill(config.accentColor)
                .frame(width: 32, height: 2)
                .cornerRadius(1)
            
            Text(config.content)
                .appTextStyle(.body, color: .appTextPrimary)
                .italic(config.isItalic)
                .lineSpacing(4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(config.backgroundColor)
        .cornerRadius(16)
    }
}

// MARK: - Preview
#Preview {
    InsightSectionCard(
        config: InsightSectionConfig(
            id: .sentence,
            emoji: "📝",
            label: "Example Sentence",
            content: "She ate a red apple for breakfast.",
            speechLanguage: "English",
            accentColor: .appAccentOrange,
            backgroundColor: .appSurfaceCardWarm
        ),
        isSpeaking: false,
        onSpeak: {}
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
