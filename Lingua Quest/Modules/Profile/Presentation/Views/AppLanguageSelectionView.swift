//
//  AppLanguageSelectionView.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import SwiftUI

struct AppLanguageSelectionView: View {
    let viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var filteredLanguages: [AppLanguage] {
        if searchText.isEmpty {
            return AppLanguage.allCases
        }
        return AppLanguage.allCases.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // App Bar (Matching SettingsAppBar)
            HStack {
                CustomBackButton(action: { dismiss() })
                
                Spacer()
                
                Text(L10n.Settings.appLanguage)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                // Invisible view for balancing
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(Color.clear)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.appBorderBrown),
                alignment: .bottom
            )
            
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
            .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredLanguages) { language in
                        Button {
                            viewModel.appLanguageCode = language.rawValue
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Text(language.flag)
                                    .appTextStyle(.displaySmall)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(Color.appSurfaceCardWarm)
                                    )
                                
                                Text(language.name)
                                    .appTextStyle(.bodyLarge, color: .appTextPrimary)
                                
                                Spacer()
                                
                                if viewModel.appLanguageCode == language.rawValue {
                                    Image(systemIcon: .checkmark)
                                        .foregroundColor(.appAccentTeal)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.appSurfaceCard)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        viewModel.appLanguageCode == language.rawValue ? Color.appAccentTeal : Color.appBorderCool,
                                        lineWidth: viewModel.appLanguageCode == language.rawValue ? 2 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}
