//
//  LanguageSelectorButton.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguageSelectorButton: View {
    let title: String
    let placeholder: String
    let selectedLanguage: Language?
    let borderColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .appTextStyle(.micro, color: .gray)

                HStack(spacing: 10) {
                    if let selectedLanguage {
                        Text(selectedLanguage.flag)
                            .font(.system(size: 20))
                            .frame(width: 20, height: 20)

                        Text(selectedLanguage.name)
                            .appTextStyle(.bodyLargeMedium, color: .appTextPrimary)
                    } else {
                        Text(placeholder)
                            .appTextStyle(.bodyLargeMedium, color: .gray.opacity(0.7))
                    }

                    Spacer()

                    Image(systemIcon: .chevronDown)
                        .appTextStyle(.captionMedium, color: .gray)
                }
            }
            .padding()
            .background(Color.appSurfaceCard)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(borderColor, lineWidth: 1.5)
            }
            .cornerRadius(18)
        }
    }
}


#Preview {
    LanguageSelectorButton(
        title: "I SPEAK...",
        placeholder: "Select language",
        selectedLanguage: Language(code: "en", name: "English", flag: "🇬🇧"),
        borderColor: Color.gray.opacity(0.15),
        action: {}
    )
}
