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
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var animateItems = false

    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return languages
        }
        return languages.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text(L10n.Onboarding.languagePickerTitle)
                .appTextStyle(.headingMedium, color: .appTextPrimary)
                .padding(.top, 16)
                .padding(.bottom, 12)

            // Search bar
            HStack(spacing: 10) {
                Image(systemIcon: .magnifyingglass)
                    .foregroundColor(.appTextSecondary.opacity(0.6))

                TextField(L10n.Onboarding.searchLanguage, text: $searchText)
                    .foregroundColor(.appTextPrimary)

                if !searchText.isEmpty {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            searchText = ""
                        }
                    } label: {
                        Image(systemIcon: .xmark)
                            .foregroundColor(.appTextSecondary.opacity(0.6))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appSurfaceCardWarm.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appBorderCool, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            // Language list
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(filteredLanguages.enumerated()), id: \.element.id) { index, language in
                        Button {
                            onSelect(language)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                isPresented = false
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text(language.flag)
                                    .appTextStyle(.displaySmall)
                                    .frame(width: 32, height: 32)

                                Text(language.name)
                                    .appTextStyle(.bodyLarge, color: .appTextPrimary)

                                Spacer()

                                Image(systemIcon: .rightChevron)
                                    .appTextStyle(.captionMedium, color: .appTextSecondary.opacity(0.4))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.appSurfaceCard.opacity(0.01))
                            )
                        }
                        .buttonStyle(.plain)
                        .opacity(animateItems ? 1 : 0)
                        .offset(y: animateItems ? 0 : 20)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(Double(index) * 0.05),
                            value: animateItems
                        )
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            animateItems = true
        }
    }
}
