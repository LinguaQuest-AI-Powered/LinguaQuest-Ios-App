import SwiftUI

struct AddLanguageView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Bindable var languageViewModel: LanguageViewModel
    
    @State private var searchText: String = ""
    @State private var selectedLanguageIds: Set<Int> = []
    
    var filteredLanguages: [AvailableLanguage] {
        if searchText.isEmpty {
            return languageViewModel.availableLanguages
        } else {
            return languageViewModel.availableLanguages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // App Bar
            HStack {
                CustomBackButton(action: { dismiss() })
                
                Spacer()
                
                // Invisible view for balancing
                Color.clear.frame(width: 44, height: 44)
            }
            .overlay(
                Text(L10n.AddLanguage.title)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
            )
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(Color.clear)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.appBorderBrown),
                alignment: .bottom
            )
            
            // Subtitle
            Text(L10n.AddLanguage.subtitle)
                .font(AppTextStyle.bodyLarge.font)
                .foregroundColor(Color.appTextSecondary)
                .padding(.top, 16)
                .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemIcon: .magnifyingglass)
                    .foregroundColor(Color.appBrandBrownDark)
                TextField(L10n.AddLanguage.searchPlaceholder, text: $searchText)
                    .font(AppTextStyle.bodyLarge.font)
                    .foregroundColor(Color.appTextPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.appBorderLight.opacity(colorScheme == .dark ? 0.7 : 0.9), lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(filteredLanguages) { language in
                        LanguageGridCell(
                            language: language,
                            isSelected: selectedLanguageIds.contains(language.id),
                            action: {
                                if selectedLanguageIds.contains(language.id) {
                                    selectedLanguageIds.remove(language.id)
                                } else {
                                    selectedLanguageIds.insert(language.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
            
            Spacer(minLength: 0)
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .overlay(alignment: .bottom) {
            // Bottom Button
            VStack {
                CustomButton(
                    type: .primary,
                    text: selectedLanguageIds.isEmpty ? L10n.AddLanguage.addSelected : L10n.AddLanguage.addSelectedFormat(selectedLanguageIds.count),
                    action: {
                        Task {
                            await languageViewModel.addLanguages(languageIds: Array(selectedLanguageIds))
                            dismiss()
                        }
                    },
                    status: selectedLanguageIds.isEmpty ? .disable : .enable
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 16)
            }
            .background(
                LinearGradient(
                    colors: [Color.appBackgroundWarm.opacity(0.0), Color.appBackgroundWarm],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .onAppear {
            Task {
                await languageViewModel.loadAvailableLanguages()
            }
        }
        .appDialog(isPresented: Binding(get: { languageViewModel.isAddingLanguages }, set: { _ in })) {
            SharedImageLoadingView(
                imageAsset: .chooseLanguageBird,
                title: L10n.Common.loading,
                subtitle: ""
            )
        }
    }
}

struct LanguageGridCell: View {
    @Environment(\.colorScheme) private var colorScheme
    let language: AvailableLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Checkmark / Radio at top right
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.appGlowTeal : Color.appBorderLight.opacity(colorScheme == .dark ? 0.7 : 0.9), lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.appGlowTeal)
                                .frame(width: 20, height: 20)
                            Image(systemIcon: .checkmark)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
                // Flag
                ZStack {
                    Circle()
                        .fill(Color.appSurfaceCardWarm)
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    Text(language.flagEmoji)
                        .font(.system(size: 36))
                }
                
                // Name
                Text(language.name)
                    .font(AppTextStyle.bodyBold.font)
                    .foregroundColor(Color.appTextPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 20)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(isSelected ? Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.15 : 0.1) : Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.94 : 0.98))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isSelected ? Color.appBrandPrimary : Color.appBorderLight.opacity(colorScheme == .dark ? 0.7 : 0.9), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// #Preview {
//     AddLanguageView(languageViewModel: LanguageViewModel(...))
// }
