import SwiftUI

struct AddLanguageView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var userLanguages: [UserLearningLanguage]
    
    @State private var searchText: String = ""
    @State private var selectedLanguages: Set<UUID> = []
    
    // All available languages from OnboardingEntities
    private let allLanguages = Language.allGlobalLanguages
    
    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return allLanguages
        } else {
            return allLanguages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                CustomBackButton {
                    dismiss()
                }
                
                Spacer()
                
                Text("Add languages")
                    .font(AppTextStyle.headingMedium.font)
                    .foregroundColor(Color.appBrandBrownDark)
                
                Spacer()
                
                // Invisible placeholder to balance the back button
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // Subtitle
            Text("Select the languages you'd like to learn")
                .font(AppTextStyle.bodyLarge.font)
                .foregroundColor(Color.appTextSecondary)
                .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.appBrandBrownDark)
                TextField("Search languages...", text: $searchText)
                    .font(AppTextStyle.bodyLarge.font)
                    .foregroundColor(Color.appTextPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.appBorderLight, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(filteredLanguages) { language in
                        LanguageGridCell(
                            language: language,
                            isSelected: selectedLanguages.contains(language.id),
                            action: {
                                if selectedLanguages.contains(language.id) {
                                    selectedLanguages.remove(language.id)
                                } else {
                                    selectedLanguages.insert(language.id)
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
                    text: selectedLanguages.isEmpty ? "Add Selected" : "Add Selected (\(selectedLanguages.count))",
                    action: {
                        addSelectedLanguages()
                        dismiss()
                    },
                    status: selectedLanguages.isEmpty ? .disable : .enable
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
    }
    
    private func addSelectedLanguages() {
        let languagesToAdd = allLanguages.filter { selectedLanguages.contains($0.id) }
        
        for lang in languagesToAdd {
            // Don't add if already exists
            if !userLanguages.contains(where: { $0.language.id == lang.id }) {
                userLanguages.append(UserLearningLanguage(language: lang, level: 1))
            }
        }
    }
}

struct LanguageGridCell: View {
    let language: Language
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
                            .stroke(isSelected ? Color.appGlowTeal : Color.appBorderLight, lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.appGlowTeal)
                                .frame(width: 20, height: 20)
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .fill(Color.white)
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
                    
                    Text(language.flag)
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
                    .fill(isSelected ? Color.appBrandPrimary.opacity(0.1) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isSelected ? Color.appBrandPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    AddLanguageView(userLanguages: .constant([]))
}
