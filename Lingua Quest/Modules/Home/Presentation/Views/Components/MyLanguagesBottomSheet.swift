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
    @Bindable var languageViewModel: LanguageViewModel
    @Binding var isPresented: Bool
    var onAddNewLanguage: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(L10n.Home.myLanguagesTitle)
                    .font(AppTextStyle.headingMedium.font)
                    .foregroundColor(Color.appTextHeading)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemIcon: .xmark)
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
                    ForEach(languageViewModel.myLanguages) { item in
                        LanguageItemRow(
                            item: item,
                            isSelected: languageViewModel.selectedLanguageId == item.id,
                            canRemove: languageViewModel.canRemoveLanguage(item),
                            action: {
                                Task {
                                    await languageViewModel.switchActiveLanguage(to: item.id)
                                    isPresented = false
                                }
                            },
                            onRemove: {
                                languageViewModel.onRemoveLanguageTapped(language: item)
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Add New Language Button
            CustomButton(
                type: .primary,
                text: L10n.Home.addNewLanguage,
                action: {
                    isPresented = false
                    onAddNewLanguage()
                },
                leading: Image(systemIcon: .plus)
            )
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .appDialog(isPresented: $languageViewModel.showRemoveConfirmation) {
            DialogCardContainer(
                showMascot: true,
                mascotImage: .loginBird, // using login bird or any available bird
                speechBubbleText: L10n.Home.removeLanguageTitle
            ) {
                VStack(spacing: 16) {
                    Text(String(format: L10n.Home.removeLanguageMessage, languageViewModel.languageToRemove?.name ?? ""))
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        CustomButton(
                            type: .secendry,
                            text: L10n.Common.cancel,
                            action: { languageViewModel.cancelRemoveLanguage() },
                            status: languageViewModel.isRemovingLanguage ? .disable : .enable
                        )
                        
                        CustomButton(
                            type: .custom(textColor: .white, buttonColor: .appSemanticError, shadowColor: .appBrandBrownDark),
                            text: L10n.Common.remove,
                            action: {
                                Task {
                                    await languageViewModel.confirmRemoveLanguage()
                                }
                            },
                            isLoading: languageViewModel.isRemovingLanguage
                        )
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}

struct LanguageItemRow: View {
    let item: MyTargetLanguage
    let isSelected: Bool
    let canRemove: Bool
    let action: () -> Void
    let onRemove: () -> Void
    
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
                    
                    Text(item.flagEmoji)
                        .font(.system(size: 28))
                }
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(AppTextStyle.bodyBold.font)
                        .foregroundColor(Color.appTextHeading)
                    
                    Text("Level \(item.level)")
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(Color.appTextSecondary)
                }
                
                Spacer()
                
                // Checkmark if selected
                if isSelected {
                    Image(systemIcon: .checkmarkCircleFill)
                        .foregroundColor(Color.appSemanticSuccess)
                        .font(.system(size: 24))
                } else if canRemove {
                    Button(action: onRemove) {
                        Image(systemIcon: .trash)
                            .foregroundColor(Color.appSemanticError)
                            .font(.system(size: 20))
                    }
                    .padding(.leading, 8)
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

// #Preview {
//     ZStack(alignment: .bottom) {
//         Color.black.opacity(0.5).ignoresSafeArea()
//         
//         CustomBottomSheet(isPresented: .constant(true), initialDetent: .medium) {
//             MyLanguagesBottomSheet(
//                 languageViewModel: LanguageViewModel(
//                     getMyLanguagesUseCase: GetMyLanguagesUseCase(repository: HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSource(apiClient: APIClient()))),
//                     getAvailableLanguagesUseCase: GetAvailableLanguagesUseCase(repository: HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSource(apiClient: APIClient()))),
//                     switchActiveLanguageUseCase: SwitchActiveLanguageUseCase(repository: HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSource(apiClient: APIClient()))),
//                     addLanguagesUseCase: AddLanguagesUseCase(repository: HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSource(apiClient: APIClient())))
//                 ),
//                 isPresented: .constant(true),
//                 onAddNewLanguage: {}
//             )
//         }
//     }
// }
