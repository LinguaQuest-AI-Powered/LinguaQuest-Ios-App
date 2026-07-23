import SwiftUI

struct LanguageSelectDialog: View {
    let onSelectEnglish: () -> Void
    let onSelectArabic: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .chooseLanguageBird,
            customMascotSize: CGSize(width: 400, height: 400),
            speechBubbleText: nil
        ) {
            VStack(spacing: 24) {
                Text(L10n.Settings.chooseLanguage)
                    .appTextStyle(.headingLarge, color: .appBrandBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentTeal, shadowColor: .appBrandBrownDark),
                        text: "English",
                        action: onSelectEnglish
                    )
                    
                    CustomButton(
                        type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentTeal, shadowColor: .appBrandBrownDark),
                        text: "العربية (Arabic)",
                        action: onSelectArabic
                    )
                    
                    OutlineButton(
                        text: L10n.Common.cancel,
                        action: onCancel
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}
