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

    var body: some View {
        NavigationStack {
            List(languages) { language in
                Button {
                    onSelect(language)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Image(language.flag)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)

                        Text(language.name)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Choose language")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
