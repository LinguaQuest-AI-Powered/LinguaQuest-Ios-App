

import SwiftUI

struct ChangePasswordSection: View {
    @Binding var oldPassword: String
    @Binding var newPassword: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(L10n.EditProfile.changePassword)
                .appTextStyle(.bodyBold, color: .appTextHeading)

            VStack(spacing: 12) {
                ProfileInputField(
                    title: "",
                    placeholder: L10n.EditProfile.oldPasswordPlaceholder,
                    icon: .lockFill,
                    isSecure: true,
                    text: $oldPassword
                )

                VStack(alignment: .leading, spacing: 6) {
                    ProfileInputField(
                        title: "",
                        placeholder: L10n.EditProfile.newPasswordPlaceholder,
                        icon: .lockFill,
                        isSecure: true,
                        text: $newPassword
                    )

                    Text(L10n.EditProfile.newPasswordHint)
                        .appTextStyle(.micro, color: .appTextSecondary)
                        .padding(.leading, 4)
                }
            }
        }
        .padding(20)
        .background(Color.appSurfaceCardWarm)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        ChangePasswordSection(
            oldPassword: .constant(""),
            newPassword: .constant("")
        )
        .padding()
    }
}
