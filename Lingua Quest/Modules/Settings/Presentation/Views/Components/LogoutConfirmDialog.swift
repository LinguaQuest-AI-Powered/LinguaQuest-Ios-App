import SwiftUI

struct LogoutConfirmDialog: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .logoutBird,
            customMascotSize: CGSize(width: 400, height: 400),
            speechBubbleText: nil
        ) {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(L10n.Settings.logOut)
                        .appTextStyle(.displayMedium, color: .appBrandBrown)
                    
                    Text(L10n.Settings.logOutConfirmation)
                        .appTextStyle(.body, color: .appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .appTextOnPrimary, buttonColor: .appAccentOrange, shadowColor: .appBrandBrownDark),
                        text: L10n.Settings.logOut,
                        action: onConfirm
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
