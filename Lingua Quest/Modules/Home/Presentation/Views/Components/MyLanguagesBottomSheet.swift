import SwiftUI

// This structure defines the learning languages with levels
struct UserLearningLanguage: Identifiable, Equatable {
    let id = UUID()
    let language: Language
    let level: Int
    
    static func == (lhs: UserLearningLanguage, rhs: UserLearningLanguage) -> Bool {
        lhs.id == rhs.id
    }
}

struct MyLanguagesBottomSheet: View {
    @Binding var isPresented: Bool
    let languages: [UserLearningLanguage]
    @Binding var selectedLanguage: UserLearningLanguage?
    var onAddNewLanguage: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("My Languages")
                    .font(AppTextStyle.headingMedium.font)
                    .foregroundColor(Color.appTextHeading)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.appTextSecondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .padding(.top, 16)
            
            // Languages List
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(languages) { item in
                        LanguageItemRow(
                            item: item,
                            isSelected: selectedLanguage?.id == item.id,
                            action: {
                                selectedLanguage = item
                                isPresented = false
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Add New Language Button
            CustomButton(
                type: .primary,
                text: "Add New Language",
                action: {
                    isPresented = false
                    onAddNewLanguage()
                },
                leading: Image(systemName: "plus")
            )
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 125)
        }
    }
}

struct LanguageItemRow: View {
    let item: UserLearningLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Flag inside circle
                ZStack {
                    Circle()
                        .fill(Color.appSurfaceCard)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle().stroke(Color.appBorderLight, lineWidth: 1)
                        )
                    
                    Text(item.language.flag)
                        .font(.system(size: 28))
                }
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.language.name)
                        .font(AppTextStyle.bodyBold.font)
                        .foregroundColor(Color.appTextHeading)
                    
                    Text("Level \(item.level)")
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(Color.appTextSecondary)
                }
                
                Spacer()
                
                // Checkmark if selected
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.appSemanticSuccess)
                        .font(.system(size: 24))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(isSelected ? Color.appBrandPrimary.opacity(0.15) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.appBrandPrimary.opacity(0.0) : Color.appBorderLight.opacity(0.0), lineWidth: 1)
            )
        }
    }
}

// Preview
#Preview {
    ZStack(alignment: .bottom) {
        Color.black.opacity(0.5).ignoresSafeArea()
        
        CustomBottomSheet(isPresented: .constant(true), initialDetent: .medium) {
            MyLanguagesBottomSheet(
                isPresented: .constant(true),
                languages: [
                    UserLearningLanguage(language: Language(code: "es", name: "Spanish", flag: "🇪🇸"), level: 12),
                    UserLearningLanguage(language: Language(code: "fr", name: "French", flag: "🇫🇷"), level: 4),
                    UserLearningLanguage(language: Language(code: "ja", name: "Japanese", flag: "🇯🇵"), level: 3)
                ],
                selectedLanguage: .constant(UserLearningLanguage(language: Language(code: "es", name: "Spanish", flag: "🇪🇸"), level: 12)),
                onAddNewLanguage: {}
            )
        }
    }
}
