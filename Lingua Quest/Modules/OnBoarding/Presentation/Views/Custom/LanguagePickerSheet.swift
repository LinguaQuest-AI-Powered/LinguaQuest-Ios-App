//
//  LanguagePickerSheet.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguagePickerSheet: View {
    let languages: [Language]
    let onSelect: (Language) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return languages
        }
        return languages.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List(filteredLanguages) { language in
                Button {
                    onSelect(language)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Text(language.flag)
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)

                        Text(language.name)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle(L10n.Onboarding.languagePickerTitle)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: L10n.Onboarding.searchLanguage)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
