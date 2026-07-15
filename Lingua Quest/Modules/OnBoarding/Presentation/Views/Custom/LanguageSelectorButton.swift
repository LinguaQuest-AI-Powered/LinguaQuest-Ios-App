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
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)

                HStack(spacing: 10) {
                    if let selectedLanguage {
                        Image(selectedLanguage.flag)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text(selectedLanguage.name)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    } else {
                        Text(placeholder)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray.opacity(0.7))
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
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
        selectedLanguage: Language(name: "English", flag: .english),
        borderColor: Color.gray.opacity(0.15),
        action: {}
    )
}
