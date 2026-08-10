import SwiftUI

struct LogoutConfirmDialog: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        DialogCardContainer(
            showMascot: true,
            mascotImage: .logoutBird,
            customMascotSize: CGSize(width: 300, height: 300),
            customTopSpacing: 70,
            speechBubbleText: nil
        ) {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(L10n.Settings.logOut)
                        .dialogTitleStyle()
                    
                    Text(L10n.Settings.logOutConfirmation)
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                VStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .white, buttonColor: .appSemanticError),
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
